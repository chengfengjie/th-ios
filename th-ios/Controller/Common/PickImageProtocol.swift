//
//  PickImageProtocol.swift
//  th-ios
//
//  Created by chengfj on 2018/3/13.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class PickImageImpl: NSObject, RootNavigationControllerProtocol,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let pickImageSignal: Signal<UIImage, RequestError>
    private let pickImageObserver: Signal<UIImage, RequestError>.Observer
    
    override init() {
        let s = Signal<UIImage, RequestError>.pipe()
        self.pickImageSignal = s.output
        self.pickImageObserver = s.input
        super.init()
    }
    
    class func create() -> PickImageImpl {
        return PickImageImpl()
    }
    
    func showPickerImageControl() {
        let alertController = UIAlertController.init(title: "选择图片",
                                                     message: "",
                                                     preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction
            .init(title: "拍照",
                  style: UIAlertActionStyle.default,
                  handler: { (action) in
                    self.presentImagePickerController(sourceType: .camera)
            }))
        alertController.addAction(UIAlertAction
            .init(title: "相册选择",
                  style: .default,
                  handler: { (action) in
                    self.presentImagePickerController(sourceType: .photoLibrary)
            }))
        alertController.addAction(UIAlertAction
            .init(title: "取消",
                  style: UIAlertActionStyle.cancel,
                  handler: nil))
        self.rootPresent(viewController: alertController, animated: true)
    }
    
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            self.pickImageObserver.send(error: RequestError.warning(message: "无权限"))
            return;
        }
        let imagePicker = UIImagePickerController()
        UIImagePickerController.isSourceTypeAvailable(sourceType)
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.rootPresent(viewController: imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.pickImageObserver.send(value: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
}

