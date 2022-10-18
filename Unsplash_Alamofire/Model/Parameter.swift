//
//  Page.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/10.
//

import Foundation

class Parameter {
    static var shared = Parameter()
    
    var page = 1
    var username: String?
    var isUserPhotos: Bool = false
    
    var quality: String {
        get {
            return PhotoQuality.shared.getPhotoQuality()
        }
    }
    
    func increasePage() {
        page += 1
    }
    
    func resetPage() {
        page = 1
    }
    
    func getUserName(username: String) {
        self.username = username
    }
    
    func resetUserName() {
        self.username = nil
    }
    
    func returnUserName() -> String {
        return username ?? ""
    }
    
    func resetIsUserPhotos() {
        self.isUserPhotos = false
    }
    
    private init() {}
}
