//
//  AlamofireManager.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire

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
}

/*
 Session을 새로 생성
 session객체를 만들때 eventMonitors 객체를 주입해주기 위해서 session객체를 새로 생성
 request를 요청할 땐 보통 AF.request()로 사용하지만, session객체를 이용
 기존의 AF는 Session.default를 보고있는 형태이므로 session을 새로만들어서 사용해도 무방
 즉, HomeVC에서 AF.request가 아닌 위에서 정의한 AlamofireManager.shared.session.request()로 접근
 */
