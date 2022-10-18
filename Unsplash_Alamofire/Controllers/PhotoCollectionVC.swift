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
    var currentLongPressedCell: PhotoCollectionViewCell?
    var isFromUserList: Bool = false
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        print("PHTOS : \(photos.count)")
        
        // Long Tap Gesture 호출
        setupLongGestureRecognizerOnCollection()
        
        print("PHOTOCOLLECTIONVC viewDidLoad - \(isFromUserList)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 디바이스 회전시 layout이 망가지는 상황을 방지
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // isFromUserList 초기화
        isFromUserList = false
        
        // Parameter의 UserPhotos를 false로 리셋 -> 리셋을 안해주고 앞에서 유저의 사진을 클릭한 상태면 라우터가 바뀌어서 잘못된 호출로 404에러가 뜬다.
        parameter.resetIsUserPhotos()
    }
}

// MARK: - CollectionView Delegate & DataSource
extension PhotoCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL.PHOTO_CELL, for: indexPath) as! PhotoCollectionViewCell
        
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
        
        cell.photoCell.sd_setImage(with: fileURL, placeholderImage: UIImage(systemName: LOADING_PHOTO.BELOW_PHOTO))
        
        
        // 셀 UI설정
        cell.photoView.layer.cornerRadius = 10
        cell.photoView.layer.borderWidth = 1.0
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.photoView.layer.backgroundColor = UIColor.white.cgColor
        cell.photoView.layer.shadowColor = UIColor.gray.cgColor
        cell.photoView.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        cell.photoView.layer.shadowRadius = 2.0
        cell.photoView.layer.shadowOpacity = 1.0
        cell.photoView.layer.masksToBounds = true
        
        cell.profileImage.layer.borderWidth = 1
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.borderColor = UIColor.black.cgColor
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height/2
        cell.profileImage.clipsToBounds = true
        
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
        
        if isFromUserList {
            AlamofireManager.shared.getUserPhotos() { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedPhotos):
                    print("PhotoCollectionVC - getUserPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                    self.photos.append(contentsOf: fetchedPhotos)
                    self.photoCollectionView.reloadData()
                    KRProgressHUD.showSuccess()
                    
                case .failure(let error):
                    
                    print("PhotoCollectionVC - getUserPhotos.failure - error : \(error.rawValue)")
                    KRProgressHUD.dismiss() {
                        self.view.makeToast("\(CustomError.endOfList.rawValue)", duration: 1.0, position: .center)
                    }
                }
                
            }
        } else {
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

// MARK: - Long Tap Gesture
extension PhotoCollectionVC: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        photoCollectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: photoCollectionView)
        
        // 제스처 시작
        if gestureRecognizer.state == .began {
            if let indexPath = photoCollectionView.indexPathForItem(at: location) {
                print("Long press at item began: \(indexPath.row)")
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self = self else { return }
                    
                    if let cell = self.photoCollectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
                        self.currentLongPressedCell = cell
                        cell.photoCell.transform = .init(scaleX: 0.9, y: 0.9)
                    }
                }
            }
            // 손 땔 때
        } else if gestureRecognizer.state == .ended {
            if let indexPath = photoCollectionView.indexPathForItem(at: location) {
                print("Long press at item end: \(indexPath.row)")
                
                
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self = self else { return }
                    if let cell = self.currentLongPressedCell  {
                        cell.photoCell.transform = .init(scaleX: 1, y: 1)
                        
                        // 사진 저장
                        if cell == self.photoCollectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {

                            let dialog = UIAlertController(title: "사진 저장", message: "사진을 저장하시겠습니까?", preferredStyle: .alert)
                            let save = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
                                guard let self = self else { return }
                                if let indexPath = self.photoCollectionView.indexPathForItem(at: location) {
                                    let imageInfo = self.photos[indexPath.row].image
                                    self.downloadImage(with: imageInfo)
                                }
                            }
                            let cancel = UIAlertAction(title: "취소", style: .cancel)

                            dialog.addAction(save)
                            dialog.addAction(cancel)
                            self.present(dialog, animated: true, completion: nil)
                        }
                    }
                }
                
            }
        } else {
            return
        }
        
        let p = gestureRecognizer.location(in: photoCollectionView)
        
        if let indexPath = photoCollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
        }
    }
}
