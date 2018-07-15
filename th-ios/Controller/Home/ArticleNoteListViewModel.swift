//
//  ArticleNoteListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/7/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleNoteListViewModel: BaseViewModel, ArticleClient {

    var requestDataAction: Action<(), JSON, HttpError>!
    
    var deleteNoteAction: Action<JSON, JSON, HttpError>!
    
    var editNoteAction: Action<JSON, AddEditNoteViewModel, HttpError>!
    
    var noteList: MutableProperty<[JSON]>!
    
    let sectionData: JSON
    init(sectionData: JSON) {
        self.sectionData = sectionData
        super.init()
        
        self.noteList = MutableProperty.init([])
        
        self.requestDataAction = Action.init(execute: { (_) -> SignalProducer<JSON, HttpError> in
            return self.createRequestDataProducer()
        })
        
        self.deleteNoteAction = Action.init(execute: { (note) -> SignalProducer<JSON, HttpError> in
            return self.createDeleteNoteProducer(noteId: note["id"].stringValue)
        })
        
        self.deleteNoteAction.completed.observeValues { (_) in
            self.requestDataAction.apply(()).start()
        }
        
        self.editNoteAction =  Action.init(execute: { (note) -> SignalProducer<AddEditNoteViewModel, HttpError> in
            let model = AddEditNoteViewModel(paraContent: self.sectionData, aid: self.sectionData["articleId"].stringValue)
            model.noteJSON = note
            model.saveNoteAction.completed.observeValues({ (_) in
                self.requestDataAction.apply(()).start()
            })
            return SignalProducer.init(value: model)
        })
    }
    
    func createRequestDataProducer() -> SignalProducer<JSON, HttpError> {
        let (singal, observer) = Signal<JSON, HttpError>.pipe()
        self.articleNoteList(articleId: self.sectionData["articleId"].stringValue,
                             sectionId: self.sectionData["sectionId"].stringValue,
                             userId: UserModel.current.userID.value)
            .observeResult { (result) in
                
                switch result {
                case let .success(data):
                    print(data)
                    self.noteList.value = data.arrayValue
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    print(error)
                    self.httpError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(singal)
    }
    
    func createDeleteNoteProducer(noteId: String) -> SignalProducer<JSON, HttpError> {
        self.isRequest.value = true
        let (singal, observer) = Signal<JSON, HttpError>.pipe()
        self.deleteArticleNote(noteId: noteId).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                self.okMessage.value = "删除笔记成功"
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                self.httpError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(singal)
    }
}
