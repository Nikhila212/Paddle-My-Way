//
//  DestinationsVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 22/09/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import SideMenu

class DestinationsVC: UIViewController {
    
    private var sideMenu: SideMenuNavigationController?
    
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet var destinationsCollectionView: UICollectionView!
    
    @IBOutlet weak var chatView: UIView!
    
    var destinationsList: [DestinationModel] = []
    var filteredList: [DestinationModel] = []
    
    var season: SeasonModel?
    var people: PeopleModel?
    
    @IBOutlet weak var clearBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearBtn.isHidden = true
        let menu = MenuListController(with: ["Home",
                                             "Profile",
                                             "History",
                                             "Logout"])
        menu.delegate = self
        
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
        self.navigationItem.hidesBackButton = true
        self.searchView.layer.cornerRadius = 25
        self.searchView.layer.borderColor = UIColor.darkGray.cgColor
        self.searchView.layer.borderWidth = 2
        
        self.chatView.layer.cornerRadius = 17
        self.chatView.layer.borderColor = UIColor.lightText.cgColor
        self.chatView.layer.borderWidth = 1
        
        destinationsCollectionView.register(UINib(nibName: "DestinationCVC", bundle: nil), forCellWithReuseIdentifier: "DestinationCVC")
        
        searchTF.addTarget(self, action: #selector(textFieldTextChanged(textfield:)), for: .editingChanged)
        
        self.getAllDestinations()
    }
    
    func logout() -> Void {
        
        do {
            
            try Auth.auth().signOut()
        } catch {}
        
        UserDefaults.standard.removeObject(forKey: "loginType")
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginAsVC") as! LoginAsVC
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = ""
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        
        present(sideMenu!, animated: true)
    }
    
    func getAllDestinations() -> Void {
        
        FirebaseTables.Destinations.observe(.value) { snapshot in
            
            self.destinationsList.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = DestinationModel()
                let id = dic["id"] as? Int ?? 0
                model.id = String(format: "%d", id)
                model.name = dic["name"] as? String ?? ""
                model.image = dic["image"] as? String ?? ""
                model.peoples = dic["peoples"] as? String ?? ""
                model.seasons = dic["seasons"] as? String ?? ""
                
                self.destinationsList.append(model)
                
            }
            self.filteredList = self.destinationsList
            
            self.destinationsCollectionView.reloadData()
        }
    }
    
    @objc func textFieldTextChanged(textfield: UITextField) -> Void {
        
        let str = textfield.text ?? ""
        filteredList = destinationsList
        if str != "" {
            
            let filtered = destinationsList.filter{ $0.name!.lowercased().contains(str.lowercased()) }
            filteredList = filtered
        }
        
        season = nil
        people = nil
        
        destinationsCollectionView.reloadData()
    }
    
    @IBAction func chatBtnClicked(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    @IBAction func filterBtnClicked(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVC") as! FiltersVC
        
        obj.delegate = self
        obj.peopleType = people
        obj.seasonType = season
        
        self.present(obj, animated: true)
    }
    
    @IBAction func clearBtnClicked(_ sender: Any) {
        
        searchTF.text = ""
        clearBtn.isHidden = true
        season = nil
        people = nil
        filteredList = self.destinationsList
        
        destinationsCollectionView.reloadData()
    }
}

extension DestinationsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        var width = 0
        let view = self.view.frame.size.width / 2
        
        width = Int(view)
        width -= 18
        
        return CGSize(width: width, height: width + 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DestinationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCVC", for: indexPath) as! DestinationCVC
        
        cell.contantView.layer.cornerRadius = 5
        cell.contantView.layer.borderWidth = 1
        cell.contantView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contantView.clipsToBounds = true
        
        cell.bgView.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.6)
        
        let dest = filteredList[indexPath.item]
        cell.nameLbl.text = dest.name ?? ""
        
        let url_str = dest.image ?? ""
        let url = URL(string: url_str)
        cell.imgView?.sd_setImage(with: url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dest = filteredList[indexPath.item]
        Constants.selectedDestination = dest
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        obj.navigationItem.title = dest.name ?? ""
        self.navigationController!.pushViewController(obj, animated: true)
    }
}

extension DestinationsVC: menuListDelegate {
    
    func didSelectedMenu(text: String) {
        
        sideMenu?.dismiss(animated: true)
        if text == "Home" {
            
            
        }else if text == "Profile" {
            
            
        }else if text == "Logout" {
            
            self.logout()
        }
    }
}


extension DestinationsVC: filterDelegate {
    
    func didFilterSelected(people: PeopleModel?, season: SeasonModel?) {
        
        searchTF.text = ""
        var filtered = destinationsList
        filteredList = filtered
        
        if people != nil {
            
            clearBtn.isHidden = false
            
            self.people = people
            let str = people?.id ?? ""
            filtered = filtered.filter{ $0.peoples!.lowercased().contains(str.lowercased()) }
            filteredList = filtered
        }
        
        if season != nil {
            
            clearBtn.isHidden = false
            
            self.season = season
            let str = season?.id ?? ""
            filtered = filtered.filter{ $0.seasons!.lowercased().contains(str.lowercased()) }
            filteredList = filtered
        }
        
        destinationsCollectionView.reloadData()
    }
}
