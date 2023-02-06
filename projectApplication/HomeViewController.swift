//
//  HomeViewController.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 22/09/2022.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var destinationsCollectionView: UICollectionView!
    
    let destinations = ["New York", "California", "Chicago", "Missouri", "New Jersey",
                        "New York", "California", "Chicago", "Missouri", "New Jersey",
                        "New York", "California", "Chicago", "Missouri", "New Jersey",
                        "New York", "California", "Chicago", "Missouri", "New Jersey"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.searchView.layer.cornerRadius = 25
        self.searchView.layer.borderColor = UIColor.lightText.cgColor
        self.searchView.layer.borderWidth = 1
        
        destinationsCollectionView.register(UINib(nibName: "DestinationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DestinationCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
        } catch {}
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        var width = 0
        let view = self.view.frame.size.width / 2
        
        width = Int(view)
        width -= 18
        
        return CGSize(width: width, height: width + 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DestinationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCollectionViewCell", for: indexPath) as! DestinationCollectionViewCell
        
        cell.contantView.layer.cornerRadius = 5
        cell.contantView.layer.borderWidth = 1
        cell.contantView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contantView.clipsToBounds = true
        
        cell.bgView.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.6)
        
        var img = destinations[indexPath.item]
        img = img.lowercased()
        img = img.replacingOccurrences(of: " ", with: "")
        img = "\(img).jpeg"
        cell.imgView.image = UIImage(named: img)
        cell.nameLbl.text = destinations[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
