//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import UIKit
protocol AddToOrderDelegate {
    func added(menuItem: MenuItem)
}

class MenuItemDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    var delegate:AddToOrderDelegate?
    var menuItem: MenuItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        updateUI()

        // Do any additional setup after loading the view.
    }
    func updateUI()
    {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
        addToOrderButton.layer.cornerRadius = 15.0
        MenuController.shared.fetchImage(url: menuItem.imageUrl) { (image, alert) in
            if let image = image
            {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            else if let alert = alert
            {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func setUpDelegate()
    {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
            let orderTableViewController = navController.viewControllers.first as? OrderTableViewController
        {
            delegate = orderTableViewController
        }

    }
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        delegate?.added(menuItem: menuItem)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
