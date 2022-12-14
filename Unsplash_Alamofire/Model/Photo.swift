//
//  Photo.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/09.
//

import Foundation

struct Photo: Codable {
    var image: String
    var username: String
    var likesCount: String
    var createdAt: String
    var photoId: String
    var profileImage: String
}
