//
//  PhotoCollectionVC.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import UIKit
import Kingfisher

class PhotoCollectionVC: BaseVC, UICollectionViewDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var input: String = ""
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        configUI()
    }
    
    func configUI() {
        
        AlamofireManager.shared.getPhotos(searchTerm: input) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedPhotos):
                print("HomeVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                
                self.photos = fetchedPhotos
                self.photoCollectionView.reloadData()
            
            case .failure(let error):
                self.view.makeToast("\(error.rawValue)", duration: 1.0, position: .center)
                print("HomeVC - getPhotos.failure - error : \(error.rawValue)")
            }
        }
    }
}


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
}

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
