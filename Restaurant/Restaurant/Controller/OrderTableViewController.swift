//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    var menuItems = [MenuItem]()
    var orderMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath)
    {
        let item = menuItems[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = String(format: "$%.2f", item.price)
        MenuController.shared.fetchImage(url: item.imageUrl) { (image, alert) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), indexPath != indexPath
                {
                    return
                }
                cell.imageView?.image = image
            }
        }
    }
    func added(menuItem: MenuItem) {
        menuItems.append(menuItem)
        let count = menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeValue()
        
    }
    func updateBadgeValue()
    {
        let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    func uploadOrder()
    {
        let menuIds = menuItems.map {$0.id}
        MenuController.shared.sumbitOrder(menuIds: menuIds) { (minutes, alert)  in
            
            if let minutes = minutes
            {
                DispatchQueue.main.async {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
                
            }
        }
    }
    @IBAction func sumbitButtonTapped(_ sender: Any) {
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        let formateOrder = String(format: "$%.2f", orderTotal)
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to sumbit your order with a total of \(formateOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sumbit", style: .default, handler: { (action) in
            self.uploadOrder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation"
        {
            menuItems.removeAll()
            tableView.reloadData()
            updateBadgeValue()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return menuItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIndentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateBadgeValue()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue"
        {
            let orderConfirmationVC = segue.destination as? OrderConfirmationViewController
            orderConfirmationVC?.minutes = orderMinutes
        }
        
    }

}
