//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-15.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}
struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
