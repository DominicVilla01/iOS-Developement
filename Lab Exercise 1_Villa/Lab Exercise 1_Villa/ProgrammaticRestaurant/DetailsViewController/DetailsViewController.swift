//
//  DetailsViewController.swift
//  Lab Exercise 1_Villa
//
//  Created by student on 2/27/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var resto: Restaurant?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.text = resto?.name ?? "No Resto Name"
        imageView?.image = UIImage(named: resto?.imageName ?? "No Resto Image")
    }
}
