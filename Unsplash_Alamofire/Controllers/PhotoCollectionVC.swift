//
//  PhotoCollectionVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Kingfisher
import KRProgressHUD
import SDWebImage

class PhotoCollectionVC: BaseVC {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos = [Photo]()
    
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
}

// MARK: - CollectionView Delegate & DataSource
extension PhotoCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photoInfo = photos[indexPath.row]
        
        let urlString = photoInfo.image
        let fileURL = URL(string: urlString)
        
        cell.usernameLabel.text = photoInfo.username
        cell.createdAtLabel.text = "업로드 날짜 : \(photoInfo.createdAt)"
        cell.likeCountLabel.text = "👍 : \(photoInfo.likesCount)개"
        cell.profileImage.kf.setImage(with: URL(string: photoInfo.profileImage))
        
        // Kingfisher로 받아올 때 이미지 다운로드 속도가 느리고 스크롤시 버벅거림이 발생하였다.
//        cell.photoCell.kf.setImage(with: fileURL, placeholder: UIImage(systemName: "text.below.photo"))
        
        
        
        // SDWebImage의 캐시 시스템을 이용한 이미지 로드
        /*
         SDWebImage란?
         이 라이브러리는 url 방식으로 이미지를 받아오는 것을 비동기적을 처리하고 그 받아온 이미지를 캐싱하여 사용할 수 있게 해주는 라이브러리다.
         그 덕분에 셀이 만들어질때 마다 url 방식으로 이미지를 받아오면서 발생한 속도 문제를 개선할 수 있게 되었다.
         */
        
        cell.photoCell.sd_setImage(with: fileURL, placeholderImage: UIImage(systemName: "text.below.photo"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageInfo = photos[indexPath.row].image
        
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

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 1
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 1.5
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - 데이터 로드 메서드
extension PhotoCollectionVC {
    func loadMoreData()  {
        
        parameter.increasePage()
        
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

// MARK: - 이미지 다운로드 메서드
extension PhotoCollectionVC {
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

