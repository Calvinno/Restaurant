//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var category: String!
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        MenuController.shared.fetchMenuItem(categoryName: category) { (menuItems, alert) in
            if let menuItems = menuItems
            {
                self.updateUI(with: menuItems)
            }
            else if let alert = alert
            {
                self.present(alert, animated: true, completion: nil)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func updateUI(with menuItems: [MenuItem])
    {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
        
    }
    func configureCell(cell: UITableViewCell, forItemAt indexPath: IndexPath)
    {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageUrl) { (image, alert) in
            if let image = image
            {
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell), indexPath != indexPath
                    {
                        return
                    }
                    cell.imageView?.image = image
                }
            }
            else if let alert = alert
            {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
        configureCell(cell: cell, forItemAt: indexPath)
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        if segue.identifier == "MenuDetailSegue"
        {
            let menuDetailViewController = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuDetailViewController.menuItem = menuItems[index]
        }
    }

}
