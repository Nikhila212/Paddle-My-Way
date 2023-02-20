//
//  WhereVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 26/09/2022.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class WhereVC: UIViewController {

    @IBOutlet var placesBtn: UIButton!
    @IBOutlet var eventsBtn: UIButton!
    @IBOutlet var reviewsBtn: UIButton!
    
    @IBOutlet var dataTableView: UITableView!
    
    var selectedTag = 0
    var ThemeColor = UIColor(named: "ThemeColor")
    
    var locations: [LocationModel] = []
    var events: [EventModel] = []
    var reviews: [ReviewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = Constants.selectedDestination?.name ?? ""
        self.setDesign(tag: 1)
        
        self.getLocations()
        self.getEvents()
        self.getReviews()
    }
    
    //MARK: Get Locations
    func getLocations() -> Void {
        
        let id = Constants.selectedDestination?.id ?? ""
        FirebaseTables.Locations.child(id).observe(.value) { snapshot in
            
            self.locations.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = LocationModel()
                model.id = dic["id"] as? String ?? ""
                model.name = dic["name"] as? String ?? ""
                model.image = dic["image"] as? String ?? ""
                model.description = dic["description"] as? String ?? ""
                
                self.locations.append(model)
            }
            
            self.dataTableView.reloadData()
        }
    }
    
    //MARK: Get Events
    func getEvents() -> Void {
        
        let id = Constants.selectedDestination?.id ?? ""
        FirebaseTables.Events.child(id).observe(.value) { snapshot in
            
            self.events.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = EventModel()
                model.id = dic["id"] as? String ?? ""
                model.category = dic["category"] as? String ?? ""
                model.date = dic["date"] as? String ?? ""
                model.image = dic["image"] as? String ?? ""
                model.link = dic["link"] as? String ?? ""
                model.name = dic["name"] as? String ?? ""
                
                self.events.append(model)
            }
        }
    }
    
    //MARK: Get Reviews
    func getReviews() -> Void {
        
        let id = Constants.selectedDestination?.id ?? ""
        FirebaseTables.Reviews.child(id).observe(.value) { snapshot in
            
            self.reviews.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = ReviewModel()
                model.id = dic["id"] as? String ?? ""
                model.rating = dic["rating"] as? Float ?? 5.0
                model.name = dic["name"] as? String ?? ""
                model.review = dic["review"] as? String ?? ""
                model.date = dic["date"] as? String ?? ""
                
                self.reviews.append(model)
            }
        }
    }
    
    
    @IBAction func places(_ sender: Any) {
        
        self.setDesign(tag: 1)
    }
    
    @IBAction func events(_ sender: Any) {
        
        self.setDesign(tag: 2)
    }
    
    @IBAction func reviews(_ sender: Any) {
        
        self.setDesign(tag: 3)
    }
    
    func setDesign(tag: Int) -> Void {
        
        placesBtn.configuration?.background.backgroundColor = .clear
        placesBtn.configuration?.background.strokeColor = ThemeColor
        placesBtn.configuration?.background.strokeWidth = 2
        placesBtn.configuration?.baseForegroundColor = ThemeColor
        
        eventsBtn.configuration?.background.backgroundColor = .clear
        eventsBtn.configuration?.background.strokeColor = ThemeColor
        eventsBtn.configuration?.background.strokeWidth = 2
        eventsBtn.configuration?.baseForegroundColor = ThemeColor
        
        reviewsBtn.configuration?.background.backgroundColor = .clear
        reviewsBtn.configuration?.background.strokeColor = ThemeColor
        reviewsBtn.configuration?.background.strokeWidth = 2
        reviewsBtn.configuration?.baseForegroundColor = ThemeColor
        
        if tag == 1 {
            
            placesBtn.configuration?.background.backgroundColor = ThemeColor
            placesBtn.configuration?.baseForegroundColor = .white
            
        }else if tag == 2 {
            
            eventsBtn.configuration?.background.backgroundColor = ThemeColor
            eventsBtn.configuration?.baseForegroundColor = .white
        }else{
            
            reviewsBtn.configuration?.background.backgroundColor = ThemeColor
            reviewsBtn.configuration?.baseForegroundColor = .white
        }
        
        selectedTag = tag
        dataTableView.reloadData()
    }
}


extension WhereVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedTag == 1 {
            
            return locations.count
        }else if selectedTag == 2 {
            
            return events.count
        }
        
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedTag == 1 {
            
            let cell = Bundle.main.loadNibNamed("PlacesTableViewCell", owner: self, options: nil)?.first as! PlacesTableViewCell
            
            cell.imgView.layer.cornerRadius = 30
            cell.imgView.clipsToBounds = true
            
            let location = locations[indexPath.row]
            
            let url_str = location.image ?? ""
            let url = URL(string: url_str)
            cell.imgView?.sd_setImage(with: url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            })
            
            cell.nameLbl.text = location.name ?? ""
            
            return cell
        }else if selectedTag == 2 {
            
            let cell = Bundle.main.loadNibNamed("EvetnsTableViewCell", owner: self, options: nil)?.first as! EvetnsTableViewCell
            
            cell.detailsView.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.6)
            
            cell.contantView.layer.cornerRadius = 12
            cell.contantView.clipsToBounds = true
            
            let event = events[indexPath.row]
            
            let url_str = event.image ?? ""
            let url = URL(string: url_str)
            cell.imgView?.sd_setImage(with: url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            })
            
            cell.nameLbl.text = event.name ?? ""
            cell.eventLbl.text = event.category ?? ""
            cell.dateLbl.text = event.date ?? ""
            
            return cell
        }
        
        let cell = Bundle.main.loadNibNamed("ReviewsTableViewCell", owner: self, options: nil)?.first as! ReviewsTableViewCell
        
        cell.contantView.layer.cornerRadius = 16
        cell.contantView.layer.borderWidth = 1
        cell.contantView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let randomInt = CGFloat.random(in: 0.0...5.0)
        cell.ratingView.value = randomInt
        cell.ratingView.tintColor = ThemeColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedTag == 1 {
            
            return 82
        }else if selectedTag == 2 {
            
            return 250
        }
        
        return UITableView.automaticDimension
    }
}
