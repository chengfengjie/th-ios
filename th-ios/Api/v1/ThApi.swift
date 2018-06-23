//
//  ThApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct Server {
    static let host_url_string: String = "http://mama16.cn/th_mobileApp/mobile.php"
    static var host_url: URL {
        return URL.init(string: host_url_string)!
    }
}

enum RequestError: Error {
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

protocol ThApi {
    var sid: String { get }
}
extension ThApi {
    
    public func encodeImage(image: UIImage) -> String {
        if let data = UIImageJPEGRepresentation(image, CGFloat.init(0.1)) {
            return "data:image/png;base64," + data.base64EncodedString()
        }
        return "";
    }
    
    @discardableResult
    public func request(method: ThMethod, data: [String: Any] = [:]) -> Signal<JSON, RequestError> {
        return Signal.init({ (observer, time) in
            let parameters = dataEncode(data: data, method: method)
            print(parameters)
            let dataRequest = Alamofire.request(Server.host_url,
                                                method: HTTPMethod.post,
                                                parameters: parameters,
                                                encoding: URLEncoding.httpBody,
                                                headers: nil)
            dataRequest.responseData { (res) in

                if res.response != nil {
                    self.parseResponseData(res: res, observer: observer, debugInfo: method.rawValue)
                } else {
                    observer.send(error: RequestError.netError)
                }
                observer.sendCompleted()
            }
            dataRequest.resume()
        })
    }
    
    private func parseResponseData(res: DataResponse<Data>, observer: Signal<JSON, RequestError>.Observer, debugInfo: String = "") {
        if let data = res.data {
            let dataJSON = JSON.init(data: data)
            if dataJSON.isEmpty {
                let text = String.init(data: data, encoding: String.Encoding.utf8)
                if let text = text {
                    print("\n" + debugInfo + "\n" + text + "\n")
                }
                observer.send(error: RequestError.server)
            } else if dataJSON["errCode"].intValue == 0 {
                observer.send(value: dataJSON["info"])
            } else if dataJSON["errCode"].stringValue == "-1" {
                UserModel.current.isLogin.value = false
                observer.send(error: RequestError.forbidden)
            } else {
                print(dataJSON)
                observer.send(error: RequestError.warning(message: dataJSON["errMessage"].stringValue))
            }
        } else {
            observer.send(error: RequestError.emptyData)
        }
    }
    
    private func dataEncode(data: [String: Any], method: ThMethod) -> Parameters {
        return [
            "m": method.rawValue,
            "params": data.json,
            "sid": self.sid,
            "format": "json",
            "sign": "",
            "phoneType": "iphone",
            "deviceInfo": ""
        ]
    }
}

extension Dictionary {
    var json: String {
        do {
            let options = JSONSerialization.WritingOptions.prettyPrinted
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            if let text = String.init(data: data, encoding: String.Encoding.utf8) {
                return text
            }
        } catch {
        }
        return ""
    }
}

extension Data {
    var json: Any {
        do {
            let options = JSONSerialization.ReadingOptions.mutableContainers
            let dict = try JSONSerialization.jsonObject(with: self, options: options)
            return dict
        } catch {
            print(error)
            return ""
        }
    }
}




