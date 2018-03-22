//
//  AddEditNoteViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AddEditNoteViewModel: BaseViewModel, ArticleApi {
    
    var noteText: MutableProperty<String>!
    
    var saveNoteAction: Action<(), JSON, RequestError>!
    
    var callBackSignal: Signal<String, NoError>!
    private var observer: Signal<String, NoError>.Observer!
    
    let paraContent: JSON
    let articleID: String
    init(paraContent: JSON, aid: String) {
        self.paraContent = paraContent
        self.articleID = aid
        super.init()
        
        self.noteText = MutableProperty(paraContent["sNoteContent"].stringValue)
        
        self.saveNoteAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                if self.paraContent["markups"].stringValue == "0" {
                    return self.createSaveNoteSiganlProducer()
                } else {
                    return self.createUpdateNoteSignalProducer()
                }
        })
        
        let (signal, observer) = Signal<String, NoError>.pipe()
        self.callBackSignal = signal
        self.observer = observer
    }
    
    private func createSaveNoteSiganlProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestAddArticleNote(articleID: self.articleID,
                              pid: self.paraContent["id"].stringValue,
                              content: self.noteText.value)
            .observeResult { (result) in
                switch result {
                case let .success(value):
                    print(value)
                    self.okMessage.value = "笔记保存成功"
                    observer.send(value: value)
                    observer.sendCompleted()
                    self.observer.send(value: self.noteText.value)
                case let .failure(error):
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }
    
    private func createUpdateNoteSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestUpdateArticleNote(articleId: self.articleID,
                                 pid: self.paraContent["id"].stringValue,
                                 content: self.noteText.value)
            .observeResult { (result) in
                switch result {
                case let .success(value):
                    print(value)
                    self.okMessage.value = "笔记保存成功"
                    observer.send(value: value)
                    observer.sendCompleted()
                    self.observer.send(value: self.noteText.value)
                case let .failure(error):
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }

}
