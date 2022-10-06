//
//  ViewController.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Alamofire
import Toast_Swift

class HomeVC: UIViewController {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var keyboardDissmissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        keyboardDissmissTapGesture.delegate = self
        
        // UI 설정
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 포커싱 주기
        self.searchBar.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        
        // 키보드 Notification 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - ConfigUI
    fileprivate func configUI() {
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        
        // 제스처 추가
        self.view.addGestureRecognizer(keyboardDissmissTapGesture)
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.getVCTitle(userInputValue + "👨‍💻")
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.getVCTitle(userInputValue + "🏞")
            
        default:
            print("default")
        }
    }
    
    // MARK: - fileprivate methods
    fileprivate func pushVC() {
        var segueId: String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = SEGUE_ID.PHOTO_COLLECTION_VC
        case 1:
            print("사용자 화면으로 이동")
            segueId = SEGUE_ID.USER_LIST_VC
        default:
            print("default")
            segueId = SEGUE_ID.PHOTO_COLLECTION_VC
        }
        
        // 화면이동
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShowHandle() called")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardSize.height < searchButton.frame.origin.y {
                print("키보드가 버튼을 덮었다.")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                self.view.frame.origin.y = distance - searchButton.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }
        

    // MARK: - IBAction methods
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC - searchFilterValueChanged() called / index : \(sender.selectedSegmentIndex)")
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        self.searchBar.becomeFirstResponder()
    }
    
    // 검색버튼 클릭
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / selectedSegmentIndex: \(searchFilterSegment.selectedSegmentIndex)")
        
        
        
        // 화면으로 이동
//        pushVC()
    }
    
}

// MARK: - Delegate methods
extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChanged() called searchText : \(searchText)")
        
        // 사용자가 입력한 값이 없을 때
        if searchText.isEmpty {
            self.searchButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                // 포커싱 해제
                searchBar.resignFirstResponder()
            }

        } else {
            self.searchButton.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() ")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("💬검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldChangeTextIn: \(searchBar.text?.appending(text).count)")
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        if inputTextCount >= 12 {
            self.view.makeToast("📢최대 12자까지 입력 가능합니다", duration: 1.0, position: .center)
            return false
        } else {
            return true
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension HomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC - gestureRecognizer shouldReceive() called")
        
        // 터치로 들어온 뷰가 searchFilterSegment면
        if touch.view?.isDescendant(of: searchFilterSegment) == true {
            print("세그먼트 터치")
            return false
        } else if touch.view?.isDescendant(of: searchBar) == true {
            print("서치바 터치")
            return false
        }
        else {
            view.endEditing(true)
            print("화면 터치")
            return true
        }
        
        
        
        
    }
}
