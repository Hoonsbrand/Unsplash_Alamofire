//
//  BaseVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit

class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("UerListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
    
    // MARK: - Get Title
    func getVCTitle(_ title: String) {
        self.vcTitle = title
    }
}
