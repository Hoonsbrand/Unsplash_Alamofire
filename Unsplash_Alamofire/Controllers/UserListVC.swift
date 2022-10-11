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
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    var users = [User]()
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        print("USERS : \(users.count)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 디바이스 회전시 layout이 망가지는 상황을 방지
        userCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - CollectionView Delegate & DataSource
extension UserListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userInfo", for: indexPath) as! UserListCollectionViewCell
        
        let userInfo = users[indexPath.row]
        
        let urlString = userInfo.thumbnail
        let fileURL = URL(string: urlString)
        
        cell.profileImage.kf.setImage(with: fileURL)
        cell.nameLabel.text = userInfo.username
        cell.likesLabel.text = "좋아요 수 : \(String(userInfo.likes))"
        cell.totalPhotosLabel.text = "총 사진 수 : \(String(userInfo.total_photos))"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Parameter.shared.getUserName(username: users[indexPath.row].username)
        
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

// MARK: - UICollectionViewDelegateFlowLayout
extension UserListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 1
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - 데이터 로드 메서드
extension UserListVC {
    func loadMoreData()  {
        
        pageClass.increasePage()
        
        AlamofireManager.shared.getUsers(searchTerm: input) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedUsers):
                print("UserListVC - loadMoreData.success - fetchedUsers.count : \(fetchedUsers.count)")
                self.users.append(contentsOf: fetchedUsers)
                self.userCollectionView.reloadData()
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
