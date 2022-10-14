//
//  UserListVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Kingfisher
import KRProgressHUD

class UserListVC: BaseVC {
    
    @IBOutlet weak var userListTableView: UITableView!
    
    var users = [User]()
    
    var fetchedPhotos = [UserPhotos]()
    var username: String?
    
// MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("USERS : \(users.count)")
        userListTableView.delegate = self
        userListTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - TableView Delegate & DataSource
extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath) as! UserListTableViewCell
        
        let userInfo = users[indexPath.row]
        
        let urlString = userInfo.profileImage
        let fileURL = URL(string: urlString)
        
        cell.userProfileImage.kf.setImage(with: fileURL)
        cell.userNameLabel.text = userInfo.username
        cell.totalPhotosLabel.text = "총 사진📷 : \(userInfo.total_photos)장"
        cell.totalLikesLabel.text = "총 좋아요👍 : \(userInfo.total_likes)개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setUsername(name: users[indexPath.row].username)
        
        userListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - 맨 밑에서 스크롤 시 데이터 로드
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것
        
        // 스크롤 할 수 있는 영역보다 더 스크롤된 경우 (하단에서 스크롤이 더 된 경우)
        if maximumOffset < currentOffset {
            
            KRProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.loadMoreData()
            }
        }
    }
}

// MARK: - 데이터 로드 메서드
extension UserListVC {
    func loadMoreData()  {
        
        parameter.increasePage()
        
        AlamofireManager.shared.getUsers(searchTerm: input) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedUsers):
                print("UserListVC - loadMoreData.success - fetchedUsers.count : \(fetchedUsers.count)")
                self.users.append(contentsOf: fetchedUsers)
                self.userListTableView.reloadData()
                KRProgressHUD.showSuccess()
                
            case .failure(let error):
                
                print("UserListVC - loadMoreData.failure - error : \(error.rawValue)")
                KRProgressHUD.dismiss() {
                    self.view.makeToast("\(CustomError.endOfList.rawValue)", duration: 1.0, position: .center)
                }
            }
        }
    }
}

// MARK: - Alamofire 호출
extension UserListVC {
    func getUserPhotos(username: String) {
        AlamofireManager.shared.getUserPhotos() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedPhotos):
                print("UserListVC - getUserPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                
                KRProgressHUD.show()
                
                let getPhotoGroup = DispatchGroup()
                getPhotoGroup.enter()
                
                DispatchQueue.global(qos: .userInteractive).async {
                    self.fetchedPhotos = fetchedPhotos
                    print("DISPATHGROUP START")
                    getPhotoGroup.leave()
                }
                
                getPhotoGroup.wait()
                print("DISPATHGROUP DONE")
                KRProgressHUD.showSuccess()
                self.pushVC()
                
            case .failure(let error):
                self.view.makeToast("\(error.rawValue)", duration: 1.0, position: .center)
                print("UserListVC - getUserPhotos.failure - error : \(error.rawValue)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! UserPhotosViewController
        nextVC.userPhotos = self.fetchedPhotos
    }
    
    fileprivate func pushVC() {
        performSegue(withIdentifier: "goToUserPhotos", sender: self)
    }
}

// MARK: - 선택된 유저 데이터 세팅
extension UserListVC {
    func setUsername(name: String) {
        self.username = name
        parameter.isUserPhotos = true
        parameter.username = username
        getUserPhotos(username: username!)
    }
}
