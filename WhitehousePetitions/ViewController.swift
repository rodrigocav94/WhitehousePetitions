//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Rodrigo Cavalcanti on 16/04/24.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Title goes here"
        content.secondaryText = "Subtitle goes here"
        cell.contentConfiguration = content

        return cell
    }
}

