//
//  MenuItem.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import Foundation

struct MenuItem: Codable
{
    var id: Int
    var name: String
    var description: String
    var price: Double
    var category: String
    var imageUrl: URL
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case description
        case price
        case category
        case imageUrl = "image_url"
    }
}

struct MenuItems: Codable
{
    let items: [MenuItem]
    
}
