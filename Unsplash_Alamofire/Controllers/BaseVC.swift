//
//  BaseVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Toast_Swift

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 인증 실패 Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup), name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 인증 실패 Notification 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    // MARK: - objc methods
    @objc func showErrorPopup(notification: NSNotification) {
        print("BaseVC - showErrorPopup()")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopup() data : \(data)")
            
            DispatchQueue.main.async {
                self.view.makeToast("📵\(data) 에러입니다.", duration: 1.5, position: .center)
            }
        }
    }
}
