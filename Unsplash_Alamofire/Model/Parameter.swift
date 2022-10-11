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
    
    func increasePage() {
        page += 1
    }
    
    func resetPage() {
        page = 1
    }
    
    func getUserName(username: String) {
        self.username = username
    }
    
    private init() {}
}
