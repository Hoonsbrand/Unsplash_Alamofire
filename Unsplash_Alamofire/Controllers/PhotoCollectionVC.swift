//
//  PhotoCollectionVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Kingfisher
import KRProgressHUD

class PhotoCollectionVC: BaseVC, UICollectionViewDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var input: String = ""
    
    var photos = [Photo]()
    
    var pageClass = Page.shared
    
    
// MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        print("PHTOS : \(photos.count)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 디바이스 회전시 layout이 망가지는 상황을 방지
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 페이지 증가하고 뒤로 갈때 다시 1로 초기화
        pageClass.page = 1
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let urlString = photos[indexPath.row].thumbnail
        let fileURL = URL(string: urlString)
        
        cell.photoCell.kf.setImage(with: fileURL)
        
        return cell
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
extension PhotoCollectionVC: UICollectionViewDelegateFlowLayout {
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

// MARK: - 데이터 로드 메서드
extension PhotoCollectionVC {
    func loadMoreData()  {
        
        pageClass.increasePage()
        
        AlamofireManager.shared.getPhotos(searchTerm: input) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedPhotos):
                print("PhotoCollectionVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                self.photos.append(contentsOf: fetchedPhotos)
                self.photoCollectionView.reloadData()
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
