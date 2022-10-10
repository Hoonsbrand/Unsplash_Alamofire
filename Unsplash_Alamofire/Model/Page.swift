//
//  Page.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/10.
//

import Foundation

class Page {
    static var shared = Page()
    
    var page = 1
    
    func increasePage() {
        page += 1
    }
    
    private init() {}
}
