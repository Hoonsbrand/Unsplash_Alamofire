//
//  PhotoCollectionViewCell.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/09.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCell: UIImageView!
    
    func update(cellImage: UIImage) {
        photoCell.image = cellImage
    }
}
