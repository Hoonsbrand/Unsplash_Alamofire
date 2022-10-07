//
//  Logger.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire

final class Logger: EventMonitor {
    
    let queue = DispatchQueue(label: "Logger")
    
    func requestDidResume(_ request: Request) {
        print("Logger - requestDidResume()")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("Logger - request.didParseResponse()")
        debugPrint(request)
    }
}

/*
 EventMonitor 프로토콜
 request, response 시점에 불리는 메소드가 들어있는 프로토콜
 구현해야할 주된 프로퍼티, 메소드는 3가지
 
 1. queue 프로퍼티
 순서대로 로깅이 이루어질 수 있도록 모든 이벤트를 queue에 담기위해 queue프로퍼티 필요
 
 2. requestDidFinish(_:) 메서드
 request가 끝나고 response가 시작될때 호출
 
 2-1. requestDidResume(_:) 메서드
 request가 시작되고 나서 호출
 
 3. request<Value>(_:didParseResponse:)
 응답을 받은 경우 호출
 */
