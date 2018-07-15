//
//  AddEditNoteViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AddEditNoteViewModel: BaseViewModel, ArticleClient {
    
    var noteText: MutableProperty<String>!
    
    var saveNoteAction: Action<(), JSON, HttpError>!
    
    var callBackSignal: Signal<String, NoError>!
    private var observer: Signal<String, NoError>.Observer!
    
    var noteJSON: JSON? {
        didSet {
            if self.noteJSON != nil {
                self.noteText.value = self.noteJSON!["content"].stringValue
            }
        }
    }
    
    let paraContent: JSON
    let articleID: String
    init(paraContent: JSON, aid: String) {
        self.paraContent = paraContent
        self.articleID = aid
        super.init()
        
        self.noteText = MutableProperty("")
        
        self.saveNoteAction = Action<(), JSON, HttpError>
            .init(execute: { (_) -> SignalProducer<JSON, HttpError> in
                return self.createSaveNoteSiganlProducer()
        })
        
        let (signal, observer) = Signal<String, NoError>.pipe()
        self.callBackSignal = signal
        self.observer = observer
    }
    
    private func createSaveNoteSiganlProducer() -> SignalProducer<JSON, HttpError> {
        if self.noteText.value.isEmpty {
            return SignalProducer.init(error: HttpError.warning(message: "笔记内容不能为空"))
        }
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        if self.noteJSON == nil {
            self.articleAddNote(articleId: self.articleID,
                                content: self.noteText.value,
                                sectionId: self.paraContent["sectionId"].stringValue,
                                userId: UserModel.current.userID.value)
                .observeResult { (result) in
                    self.isRequest.value = false
                    switch result {
                    case let .success(data):
                        self.okMessage.value = "保存成功"
                        observer.send(value: data)
                        observer.sendCompleted()
                    case let .failure(error):
                        self.httpError.value = error
                        observer.send(error: error)
                    }
            }
        } else {
            self.updateArticleNote(noteId: self.noteJSON!["id"].stringValue, content: self.noteText.value).observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    self.okMessage.value = "保存成功"
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
                
            }
        }

        return SignalProducer.init(signal)
    }
    
}
