//
//  User.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/11.
//

import Foundation

struct User: Codable {
    var likes: Int
    var username: String
    var total_photos: Int
    var thumbnail: String
}
