//
//  ArticleClient.swift
//  th-ios
//
//  Created by chengfj on 2018/6/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol ArticleClient: RestClient {
    
}

extension ArticleClient {
    
    func getHomeLabelList() -> Signal<JSON, HttpError> {
        return self.request(requestURI: RequestURI.homeLabelList, method: HTTPMethod.get)
    }
}
