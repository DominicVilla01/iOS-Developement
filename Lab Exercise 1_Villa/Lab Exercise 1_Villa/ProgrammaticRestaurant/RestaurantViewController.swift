//
//  RestaurantViewController.swift
//  Lab Exercise 1_Villa
//
//  Created by student on 2/27/23.
//

import UIKit

struct Restaurant {
    var imageName: String
    var name: String
    var isTextHidden: Bool = false
    var isTweetHorizontal: Bool = false
}

class RestaurantViewController: UITableViewController{
    private static let RestaurantTableCellReuseIdentifier = "TableCell_ID"
    
    var restaurants = [
        Restaurant(imageName: "jollibeeImage", name: "Jolibee"),
        Restaurant(imageName: "mcdoPic", name: "McDonald's"),
        Restaurant(imageName:"Wendys", name: "Wendy's"),
        Restaurant(imageName: "kFc", name: "KFC"),
        Restaurant(imageName: "burgerKing", name: "Burger King"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: RestaurantViewController.RestaurantTableCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantViewController.RestaurantTableCellReuseIdentifier, for: indexPath) as? RestaurantTableViewCell
        else{ return UITableViewCell() }
        
        let resto = restaurants[indexPath.row]
        cell.stackView.axis = resto.isTweetHorizontal ? .horizontal : .vertical
        cell.restoLabel.isHidden = resto.isTextHidden
        cell.restoLabel.text = resto.name
        cell.restoImageView.image = UIImage(named: resto.imageName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let resto = restaurants[indexPath.row]
        goToDetailsViewController(resto: resto)
    }
    
    func goToDetailsViewController(resto: Restaurant) {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: "restoDV_ID") as? DetailsViewController else { return }
        detailsViewController.resto = resto
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
}
