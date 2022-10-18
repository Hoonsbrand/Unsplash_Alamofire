//
//  Constants.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollectionVC"
    static let USER_PHOTOS_VC = "goToUserPhotos"
}

enum CELL {
    static let PHOTO_CELL = "photoCell"
}

enum API {
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let CLIENT_ID: String = Bundle.main.UNSPLASH_API_KEY
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}

enum SEARCH_BAR_TITLE {
    static let PHOTO_KEYWORD = "사진 키워드"
    static let USER_NAME = "사용자 이름"
}

enum LOADING_PHOTO {
    static let BELOW_PHOTO = "text.below.photo"
}

extension Bundle {
    var UNSPLASH_API_KEY: String {
        guard let file = self.path(forResource: "UnsplashInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["UNSPLASH_API_KEY"] as? String else {
            fatalError("UNSPLASH_API_KEY error")
        }
        return key
    }
}
