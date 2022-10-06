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
    
    // 세션
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
