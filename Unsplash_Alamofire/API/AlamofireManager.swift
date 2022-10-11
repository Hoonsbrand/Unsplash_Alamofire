//
//  AlamofireManager.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager {
    
    
    
    // 싱글톤 적용
    static let shared = AlamofireManager()
    
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거
    let monitors = [Logger(), ApiStatusLogger()] as [EventMonitor]
    
    // 세션, 맨 밑 주석 참고
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    // MARK: - Get Photos method
    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], CustomError>) -> Void) {
        
        print("AlamofireManager - getPhotos() called userInput : \(userInput)")
        self.session                                                            // AlamofireManager에서 만든 세션
            .request(SearchRouter.searchPhotos(term: userInput))                // 만들어 놓은 세션에서 request에 접근
            .validate(statusCode: 200...400)                                    // 유효성 검사 - 유효성검사는 요청에 대한 response를 하기 전에 .validate()를 호출함으로써 유효하지 않은 상태 코드나 MIME타입이 있는 경우 response하지 않도록 한다.
            .responseJSON { [weak self] response in                                         // 유효성 검사를 통과하면 data 응답 받음
                
                guard let self = self else { return }
                
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                
                var photos = [Photo]()
                
                print("jsonArray.size : \(jsonArray.count)")
                
                for (index, subJson) : (String, JSON) in jsonArray {
                    print("index : \(index), subJson : \(subJson)")
                    
                    // 데이터 파싱
                    guard let image = subJson["urls"]["full"].string,
                          let username = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else { return }
                    
                    let likesCount = subJson["likes"].intValue
                    
                    let photoItem = Photo(image: image, username: username, likesCount: likesCount, createdAt: createdAt)
                    
                    // 배열에 넣고
                    photos.append(photoItem)
                }
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
            }
    }
    
    // MARK: - Get Users method
    func getUsers(searchTerm userInput: String, completion: @escaping (Result<[User], CustomError>) -> Void) {
        
        print("AlamofireManager - getUsers() called userInput : \(userInput)")
        self.session                                                            // AlamofireManager에서 만든 세션
            .request(SearchRouter.searchUsers(term: userInput))                // 만들어 놓은 세션에서 request에 접근
            .validate(statusCode: 200...400)                                    // 유효성 검사 - 유효성검사는 요청에 대한 response를 하기 전에 .validate()를 호출함으로써 유효하지 않은 상태 코드나 MIME타입이 있는 경우 response하지 않도록 한다.
            .responseJSON { [weak self] response in                                         // 유효성 검사를 통과하면 data 응답 받음
                
                guard let self = self else { return }
                
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                
                var users = [User]()
                
                print("jsonArray.size : \(jsonArray.count)")
                
                for (index, subJson) : (String, JSON) in jsonArray {
                    print("index : \(index), subJson : \(subJson)")
                    
                    // 데이터 파싱
                    guard let thumbnail = subJson["urls"]["thumb"].string,
                          let username = subJson["user"]["username"].string else { return }
                    
                    let totalPhotos = subJson["user"]["total_photos"].intValue
                    let likesCount = subJson["likes"].intValue
                    
                    let userItem = User(likes: likesCount, username: username, total_photos: totalPhotos, thumbnail: thumbnail)
                    
                    // 배열에 넣고
                    users.append(userItem)
                }
                if users.count > 0 {
                    completion(.success(users))
                } else {
                    completion(.failure(.noContent))
                }
            }
    }
}
    
    /*
     Session을 새로 생성
     session객체를 만들때 eventMonitors 객체를 주입해주기 위해서 session객체를 새로 생성
     request를 요청할 땐 보통 AF.request()로 사용하지만, session객체를 이용
     기존의 AF는 Session.default를 보고있는 형태이므로 session을 새로만들어서 사용해도 무방
     즉, HomeVC에서 AF.request가 아닌 위에서 정의한 AlamofireManager.shared.session.request()로 접근
     */
