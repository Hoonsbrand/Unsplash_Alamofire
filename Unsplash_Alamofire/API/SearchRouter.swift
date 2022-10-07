//
//  SearchRouter.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire

// 라우터? -> request를 만든다는 컨셉
/*집에 있는 라우터를 먼저 떠올려보면, 집으로 들어오는 하나의 네트워크 선이 라우터를 통해 여러 컴퓨터에 연결할 수 있고 와이파이도 만들어줍니다. 앱에서의 라우터도 비슷한 느낌이죠. 하나의 앱에선 여러 API 요청이 발생하는데 Reqeust Router을 통해서 모든 요청을 생성할 수 있고, 이를 통해 API 요청 로직을 일관적으로 관리할 수 있습니다. API 요청할 때마다 Reqeust를 정의하는 코드가 여기저기 흩어져서 불안했다면 라우터를 만들어서 내 관리하에 있다는 안정감을 얻을 수 있을 것입니다
 */

// 검색관련 api
// 라우터를 디자인하는게 중요한데 URLRequestConvertible 프로토콜이 그걸 가능하게 해준다는 내용.
enum SearchRouter: URLRequestConvertible {
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    // 기본 URL
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    // HTTPMethod 분기처리
    var method: HTTPMethod {
        // 한가지 방식으로 할 때
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
        
        // 두가지 이상 방식
//        switch self {
//        case .searchPhotos:
//            return .get
//        case .searchUsers:
//            return .post
//        }
    }
    
    // endPoint 설정 분기처리
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    // 유저가 원하는 값을 파라미터로 전달하기위하여 query에 넣음
    var parameters: [String: String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        }
    }
    
    // 위에서 설정한 값들을 바탕으로 request 객체 생성
    func asURLRequest() throws -> URLRequest {
        
        // 기본URL에 endPoint 추가 한 후! URL로 return
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("MySearchRouter - asURLRequest() url : \(url)")
        
        // URLRequest객체 생성
        var request = URLRequest(url: url)
        
        // 분기처리 된 method 적용
        request.method = method
            
        // 제일 밑 주석 참고
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
//
        // request 객체 return
        return request
    }
}

/*
 Alamofire에는 ParameterEncoder를 따르는 JSONParameterEncoder와 URLEncodedFormParameterEncoder를 포함한다. 이 두가지 방식이 가장 흔히 사용되는 인코딩 방식이라고 한다.
 URLEncodedFormParameterEncode는 URL 인코딩 문자열로 값을 인코딩해 기존 URL 쿼리 문자열로 설정 및 추가하거나 request의 HTTP body로 설정한다.
 유저로부터 입력받은 값인 파라미터를 request객체에 담겨준다.
 error를 catch 해줄 필요가 없는 이유는 이미 asURLRequest()가 throws 하기 때문이다.
 */
