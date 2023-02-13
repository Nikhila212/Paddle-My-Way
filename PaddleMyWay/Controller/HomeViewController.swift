//
//  HomeViewController.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 22/09/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet var destinationsCollectionView: UICollectionView!
    
    @IBOutlet weak var chatView: UIView!
    
    var destinationsList: [Destination] = []
    var filteredList: [Destination] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.searchView.layer.cornerRadius = 25
        self.searchView.layer.borderColor = UIColor.lightText.cgColor
        self.searchView.layer.borderWidth = 1
        
        self.chatView.layer.cornerRadius = 17
        self.chatView.layer.borderColor = UIColor.lightText.cgColor
        self.chatView.layer.borderWidth = 1
        
        destinationsCollectionView.register(UINib(nibName: "DestinationCVC", bundle: nil), forCellWithReuseIdentifier: "DestinationCVC")
        
        searchTF.addTarget(self, action: #selector(textFieldTextChanged(textfield:)), for: .editingChanged)
        
        self.getAllDestinations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getAllDestinations() -> Void {
        
        FirebaseTables.Destinations.observe(.value) { snapshot in
            
            self.destinationsList.removeAll()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                dict.setValue(snap.key, forKey: "id")
                
                var model = Destination()
                model.id = dict["id"] as? String ?? ""
                model.name = dict["name"] as? String ?? ""
                model.image = dict["image"] as? String ?? ""
                
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
        
        destinationsCollectionView.reloadData()
    }
    
    @IBAction func chatBtnClicked(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController!.pushViewController(obj, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    }
}
