//
//  MoyaLoggerPlugin.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            var log = "네트워크 요청 실패\n"
            log += "---------------------------------------------\n"
            log += "httpRequest가 잘못되었습니다.\n"
            log += "---------------------------------------------"
            
            
            Log.fault(log, .networking)
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "네트워크 요청 성공\n"
        log += "---------------------------------------------\n"
        log += "Method: \(method)\n"
        log += "URL: \(url)\n"
        log += "API: \(target)\n"
        
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log += "header: \(headers)\n"
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log += "bodyString: \(bodyString)\n"
        }
        
        log += "---------------------------------------------"
        Log.debug(log, .networking)
    }
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSucceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "네트워크 통신 성공\n"
        log += "---------------------------------------------\n"
        log += "statusCode: \(statusCode)\n"
        log += "URL: \(url)\n"
        log += "API: \(target)\n"
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("response.data: \(reString)\n")
        }
        log += "data size: \(response.data.count)byte\n"
        log += "---------------------------------------------"
        Log.debug(log, .networking)
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSucceed(response, target: target, isFromError: true)
            return
        }
        var log = "네트워크 통신 실패\n"
        log += "---------------------------------------------\n"
        log += "Error - \(error.failureReason ?? error.errorDescription ?? "unknown error")\n"
        log += "ErrorCode - \(error.errorCode)\n"
        
        if let data = error.response?.data {
            log += "Data - \(data)\n"
        } else {
            log += "Data - empty\n"
        }
        
        log += "---------------------------------------------"
        Log.error(log, .networking)
    }
}
