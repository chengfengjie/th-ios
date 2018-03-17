//
//  PublishTopicViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TopicImageAttachment: NSTextAttachment {
    var imagePath: String = ""
}

class PublishTopicViewModel: BaseViewModel, QingApi {

    var title: MutableProperty<String>!
    
    var contentAttributeText: MutableProperty<NSAttributedString>!
    
    var currentType: MutableProperty<JSON>!
    
    var selectTopicCateAction: Action<(), SelectTopicCateViewModel, NoError>!
    
    var publishAction: Action<(), JSON, RequestError>!
    
    var uploadImageAction: Action<Data, JSON, RequestError>!
    
    let fid: String
    let catelist: [JSON]
    init(fid: String, catelist: [JSON]) {
        self.fid = fid
        self.catelist = catelist
        super.init()
        
        print(fid)
        print(catelist)
        
        self.title = MutableProperty("")
        
        self.contentAttributeText = MutableProperty(NSAttributedString())
        
        self.currentType = MutableProperty(self.catelist[0])
        
        self.selectTopicCateAction = Action<(), SelectTopicCateViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<SelectTopicCateViewModel, NoError> in
                let viewModel = SelectTopicCateViewModel(catelist: self.catelist)
                viewModel.selectAction.values.observeValues({ (selectCateJSON) in
                    self.currentType.value = selectCateJSON
                })
                return SignalProducer.init(value: viewModel)
        })
        
        self.publishAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createPublishSignalProducer()
        })
        
        self.uploadImageAction = Action<Data, JSON, RequestError>
            .init(execute: { (data) -> SignalProducer<JSON, RequestError> in
                return self.createUploadImageSignalProducer(imageData: data)
        })
    }
    
    private func createPublishSignalProducer() -> SignalProducer<JSON, RequestError> {
        
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
       
        let text: NSAttributedString = contentAttributeText.value
        
        var contentText: String = ""
        
        var imageIndex: Int = 1
       
        var imageIndexDict: [String: String] = [:]
        
        text.enumerateAttributes(
            in: NSRange.init(location: 0, length: text.length),
            options: .longestEffectiveRangeNotRequired) { (attrs, range, flag) in

            if let attachment = attrs[NSAttributedStringKey.attachment] as? TopicImageAttachment {
                contentText = contentText + "[at]\(imageIndex)[/at]"
                imageIndexDict[imageIndex.description] = attachment.imagePath
                imageIndex = imageIndex + 1
            } else {
                contentText = contentText + text.attributedSubstring(from: range).string
            }
        }
        
        print(contentText)
        print(imageIndexDict)
        
        self.isRequest.value = true
        requestPublishTopic(
            fid: self.fid,
            typeId: self.currentType.value["typeid"].stringValue,
            title: self.title.value,
            message: contentText,
            pic: imageIndexDict)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case let .failure(error):
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        
        return SignalProducer.init(signal)
    }
    
    private func createUploadImageSignalProducer(imageData: Data) -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestUploadTopicImage(dataString: imageData.base64EncodedString()).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
}
