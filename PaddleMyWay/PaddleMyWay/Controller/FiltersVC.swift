//
//  FiltersVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 23/09/2022.
//

import UIKit
import FirebaseDatabase

protocol filterDelegate {
    
    func didFilterSelected(people: PeopleModel?, season: SeasonModel?)
}

class FiltersVC: UIViewController {
    
    var delegate: filterDelegate?
    
    @IBOutlet weak var seasonTV: UITableView!
    @IBOutlet weak var seasonTF: UITextField!
    
    
    @IBOutlet weak var peoplesTV: UITableView!
    @IBOutlet weak var peoplesTF: UITextField!
    
    
    var allPeoples: [PeopleModel] = []
    var allSeasons: [SeasonModel] = []
    
    var peopleType: PeopleModel?
    var seasonType: SeasonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        seasonTF.text = seasonType?.name ?? ""
        peoplesTF.text = peopleType?.name ?? ""
        
        self.getPeoples()
        self.getSeasons()
        
        self.seasonTV.isHidden = true
        self.peoplesTV.isHidden = true
    }
    
    func getPeoples() -> Void {
        
        FirebaseTables.Peoples.observe(.value) { snapshot in
            
            self.allPeoples.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = PeopleModel()
                model.id = dic["id"] as? String ?? ""
                model.name = dic["name"] as? String ?? ""
                
                
                self.allPeoples.append(model)
            }
            
            self.peoplesTV.reloadData()
        }
    }
    
    func getSeasons() -> Void {
        
        FirebaseTables.Seasons.observe(.value) { snapshot in
            
            self.allSeasons.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var model = SeasonModel()
                model.id = dic["id"] as? String ?? ""
                model.name = dic["name"] as? String ?? ""
                
                self.allSeasons.append(model)
            }
            
            self.seasonTV.reloadData()
        }
    }
    
    @IBAction func seasonBtn(_ sender: Any) {
        
        seasonTV.isHidden = false
    }
    
    
    @IBAction func peoplesBtn(_ sender: Any) {
        
        peoplesTV.isHidden = false
    }
    
    @IBAction func submit(_ sender: Any) {
        
        self.delegate?.didFilterSelected(people: peopleType, season: seasonType)
        self.dismiss(animated: true)
    }
}

extension FiltersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return allSeasons.count
        }
        
        return self.allPeoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        if tableView.tag == 1 {
            
            cell.textLabel?.text = self.allSeasons[indexPath.row].name ?? ""
        }else {
            
            cell.textLabel?.text = self.allPeoples[indexPath.row].name ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            seasonType = self.allSeasons[indexPath.row]
            seasonTF.text = self.seasonType?.name ?? ""
            
            seasonTV.isHidden = true
        }else {
            
            peopleType = self.allPeoples[indexPath.row]
            peoplesTF.text = self.peopleType?.name ?? ""
            
            peoplesTV.isHidden = true
        }
    }
}
