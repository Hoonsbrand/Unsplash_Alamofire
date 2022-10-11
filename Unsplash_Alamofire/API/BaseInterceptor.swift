//
//  BaseInterceptor.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    var parameter = Parameter.shared
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
            
        var request = urlRequest
        
        // API호출 시 adapt에서 가로채서 urlRequest에 application/json과 accessToken을 추가한 urlRequest으로 다시 반환
        // RequestInterceptor를 준수하여 adapt메서드에서 구현
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        // 공통 파라미터 추가
        var dictionary = [String: String]()
        var page = parameter.page
        
        dictionary.updateValue(API.CLIENT_ID, forKey: "client_id")
        dictionary.updateValue("30", forKey: "per_page")
        dictionary.updateValue("\(page)", forKey: "page")
        
        if let username = parameter.username {
            dictionary.updateValue(username, forKey: "username")
        }
        
        do {
            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
        } catch {
            print(error)
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode]
        
        NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
        
        completion(.doNotRetry)
    }
}

/*
 인터셉터?
 서버에 요청을 보내기 전에, 중간에 가로채서 어떤 작업을 한 뒤 다시 서버로 보내는 역할
 Alamofire를 사용하면 RequestInterceptor 프로토콜을 준수한 클래스의 인스턴스를 request에 실어서 보내면 동작
 adapt(): API 호출 전에 urlRequest에 관한 처리를 가로채서 적용하는 메서드
 retry(): API 호출 결과로 Error가 발생한 경우, 처리한 다음에 Error가 발생한 API를 다시 호출할것인지 적용하는 메서드
 
 RequestInterceptor 프로토콜
 RequestAdaptor와 RequestRetrier의 성격을 가지고 있는 프로토콜
 
 RequestAdaptor - adapt 메서드
 request전에 특정 작업을 하고싶은 경우 사용 (여기서는 헤더에 값 추가)
 여러 api호출 시 공통으로 사용되는 파라미터도 인터셉터에서 추가해 줄 수 있다.
 
 RequestRetrier - retry 메서드
 요청을 재시도해야하는지 여부를 결정하는 메소드
 completion으로 RetryResult를 넘기며, 재시도하는 유형에 대한 값
 */
