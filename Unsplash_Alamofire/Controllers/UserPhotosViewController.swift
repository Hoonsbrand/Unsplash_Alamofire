//
//  UserPhotosViewController.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/13.
//

import UIKit
import KRProgressHUD
import Kingfisher

class UserPhotosViewController: BaseVC {

    @IBOutlet weak var userPhotosCollectionView: UICollectionView!
    
    var userPhotos = [UserPhotos]()
    
// MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userPhotos)
        userPhotosCollectionView.delegate = self
        userPhotosCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhotosCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Parameter.shared.isUserPhotos = false
    }
}


// MARK: - CollectionView Delegate & DataSource
extension UserPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotosCollectionViewCell
        
        let urlString = userPhotos[indexPath.row].image
        let fileURL = URL(string: urlString)
        
        cell.userPhotoImage.sd_setImage(with: fileURL, placeholderImage: UIImage(systemName: "text.below.photo"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageInfo = userPhotos[indexPath.row].image
        
        downloadImage(with: imageInfo)
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
extension UserPhotosViewController {
    func loadMoreData()  {
        
        parameter.increasePage()
        
        AlamofireManager.shared.getUserPhotos() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedPhotos):
                print("PhotoCollectionVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                self.userPhotos.append(contentsOf: fetchedPhotos)
                self.userPhotosCollectionView.reloadData()
                KRProgressHUD.showSuccess()
                
            case .failure(let error):
                
                print("PhotoCollectionVC - getPhotos.failure - error : \(error.rawValue)")
                KRProgressHUD.dismiss() {
                    self.view.makeToast("\(CustomError.endOfList.rawValue)", duration: 1.0, position: .center)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - 이미지 다운로드 메서드
extension UserPhotosViewController {
    private func downloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                UIImageWriteToSavedPhotosAlbum(value.image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                // 저장 완료
                
            case .failure(let error):
                // 에러 발생!
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        // 사진 저장 한 후
        if let error = error {
            // 에러 발생!
            view.makeToast("사진 저장에 실패했습니다!", duration: 1.0, position: .center)
            
        } else {
            // 저장 완료
            view.makeToast("사진 저장 완료!", duration: 1, position: .center)
        }
    }
}
