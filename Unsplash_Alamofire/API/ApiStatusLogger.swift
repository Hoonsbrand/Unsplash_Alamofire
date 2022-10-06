//
//  ApiStatusLogger.swift
//  Unsplash_Alamofire
//
//  Created by hoonsbrand on 2022/10/06.
//

import Foundation
import Alamofire

final class ApiStatusLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "ApiStatusLogger")
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        
        guard let statusCode = request.response?.statusCode else { return }
                
        print("ApiStatusLogger - statusCode: \(statusCode)")
//        debugPrint(request)
    }
}
