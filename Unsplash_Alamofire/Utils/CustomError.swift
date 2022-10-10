//
//  CustomError.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/09.
//

import Foundation

enum CustomError: String, Error {
    case noContent = "😵검색 결과가 없습니다."
    case endOfList = "🤔마지막 결과입니다."
}
