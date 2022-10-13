//
//  UserListTableViewCell.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/13.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalPhotosLabel: UILabel!
    @IBOutlet weak var totalLikesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
