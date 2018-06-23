//
//  RestClient.swift
//  th-ios
//
//  Created by chengfj on 2018/6/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct HttpServer {
    static let host_url_string: String = "http://localhost:10005"
    static func buildUrl(uri: RequestURI) -> URL {
        return URL.init(string: host_url_string + uri.rawValue)!
    }
}

enum HttpError: Error {
    case error
    case warning(message: String)
    case forbidden
    case netError
    case emptyData
    case server
    case noError
    
    var localizedDescription: String {
        switch self {
        case .error:
            return "系统错误"
        case .forbidden:
            return "请登录"
        case let .warning(message):
            return message
        case .netError:
            return "网络错误"
        case .emptyData:
            return "无返回数据"
        case .server:
            return "服务器内部错误"
        case .noError:
            return ""
        }
    }
}

protocol RestClient {}

extension RestClient {
    
    @discardableResult
    public func request(requestURI: RequestURI, parameters: [String: Any] = [:], method: HTTPMethod) -> Signal<JSON, HttpError> {
        return Signal.init({ (observer, time) in
            let dataRequest = Alamofire.request(HttpServer.buildUrl(uri: requestURI),
                                                method: method,
                                                parameters: parameters,
                                                encoding: URLEncoding.httpBody,
                                                headers: nil)
            dataRequest.responseData { (res) in
                if res.response != nil {
                    self.parseResponseData(res: res, observer: observer, debugInfo: requestURI.rawValue)
                } else {
                    observer.send(error: HttpError.netError)
                }
                observer.sendCompleted()
            }
            dataRequest.resume()
        })
    }
    
    private func parseResponseData(res: DataResponse<Data>, observer: Signal<JSON, HttpError>.Observer, debugInfo: String = "") {
        if let data = res.data {
            let dataJSON = JSON.init(data: data)
            if dataJSON.isEmpty {
                let text = String.init(data: data, encoding: String.Encoding.utf8)
                if let text = text {
                    print("\n" + debugInfo + "\n" + text + "\n")
                }
                observer.send(error: HttpError.server)
            } else if dataJSON["code"].intValue == 0 {
                observer.send(value: dataJSON["data"])
            } else if dataJSON["code"].stringValue == "2" {
                UserModel.current.isLogin.value = false
                observer.send(error: HttpError.forbidden)
            } else {
                print(dataJSON)
                observer.send(error: HttpError.warning(message: dataJSON["errorMessage"].stringValue))
            }
        } else {
            observer.send(error: HttpError.emptyData)
        }
    }
    
}
