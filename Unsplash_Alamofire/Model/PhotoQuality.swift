//
//  PhotoQuality.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/14.
//

import Foundation

enum PhotoQualityEnum: String {
    case small, regular, full
}

class PhotoQuality {
    static var shared = PhotoQuality()
    
    private var quality: PhotoQualityEnum = .regular
    
    func getPhotoQuality() -> String {
        return quality.rawValue
    }
    
    func setPhotoQuality(quality: PhotoQualityEnum) {
        self.quality = quality
    }
}


