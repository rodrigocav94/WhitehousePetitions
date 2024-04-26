//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Rodrigo Cavalcanti on 16/04/24.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    let searchBarController = UISearchController(searchResultsController: nil)
    var filteredData = [Petition]()
    var urlString  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setSearchBarUI()
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredData[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1
        content.text = petition.title
        content.secondaryText = petition.body
        cell.contentConfiguration = content

        return cell
    }
    
    @objc func fetchJSON() {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            performSelector(onMainThread: #selector(getFilteredData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func setupNavBar() {
        title = "Whitehouse Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true

        let creditsButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(onTapCredits)
        )
        navigationItem.rightBarButtonItem = creditsButton
    }
    
    @objc func onTapCredits() {
        let ac = UIAlertController(
            title: "Credits",
            message: "The data for this app comes from the We The People API of the Whitehouse",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}



extension ViewController: UISearchBarDelegate {
    func setSearchBarUI() {
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        navigationItem.searchController = searchBarController
    }
    
    @objc func getFilteredData(searchedText: String = String()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let filteredListData: [Petition] = self.petitions.filter({ (object) -> Bool in
                searchedText.isEmpty ? true : object.title.lowercased().contains(searchedText.lowercased())
            })
            DispatchQueue.main.async {
                self.filteredData = filteredListData
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getFilteredData(searchedText: searchBar.text ?? String())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
        getFilteredData()
    }
    
}
