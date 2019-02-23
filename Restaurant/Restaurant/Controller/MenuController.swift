//
//  MenuController.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import Foundation
import UIKit

class MenuController
{
    static let shared = MenuController()
    let baseUrl = URL(string: "http://localhost:8090/")!
    
    func fetchCategories(completition: @escaping ([String]?, UIAlertController?) -> Void)
    {
        let categoryUrl = baseUrl.appendingPathComponent("categories")
        print(categoryUrl)
        let task = URLSession.shared.dataTask(with: categoryUrl) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data
            {
                let categories = try? jsonDecoder.decode(Categories.self, from: data)
                completition(categories?.categories, nil)
            }
            else if let error = error
            {
                let alertController = UIAlertController(title: "An error occured", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                completition(nil, alertController)
                
            }
            else
            {
                print("Whaaaaat!?")
            }
        }
        task.resume()
    }
    func fetchMenuItem(categoryName: String, completition: @escaping ([MenuItem]?, UIAlertController?) -> Void)
    {
        let initialMenuURL = baseUrl.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        print(menuURL)
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data)
            {
                completition(menuItems.items, nil)
            }
            else if let error = error
            {
                let alertController = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                completition(nil, alertController)
            }
        }
        
        task.resume()
    }
    func sumbitOrder(menuIds: [Int], completition: @escaping (Int?, UIAlertController?) -> Void)
    {
        let orderUrl = baseUrl.appendingPathComponent("order")
        
        var request = URLRequest(url: orderUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data
            {
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data)
                completition(preparationTime?.prepTime, nil)
            }
            else if let error = error
            {
                let alertController = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                completition(nil, alertController)
            }
        }
        task.resume()
    }
    func fetchImage(url: URL, completition: @escaping (UIImage?, UIAlertController?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data
            {
                let image = UIImage(data: data)
                completition(image, nil)
            }
            else if let error = error
            {
                let alertController = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                completition(nil, alertController)
            }
        }
        task.resume()
    }
    
}

