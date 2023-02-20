//
//  MenuListController.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 07/02/2023.
//

import UIKit
import FirebaseAuth

protocol menuListDelegate {
    
    func didSelectedMenu(text: String) -> Void
}

class MenuListController: UITableViewController {

    var delegate: menuListDelegate?
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    
    private let menuItems: [String]
    var darkColor = UIColor(red: 33/255.0,
                            green: 33/255.0,
                            blue: 33/255.0,
                            alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = darkColor
        tableView.backgroundColor = darkColor
    }
    
    init(with menuItems: [String]) {
        
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = darkColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.backgroundColor = darkColor
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = menuItems[indexPath.row]
        delegate?.didSelectedMenu(text: item)
    }
}
