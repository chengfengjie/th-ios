//
//  PublishTopicViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class PublishTopicViewController: BaseViewController<PublishTopicViewModel>,
PublishTopicViewLayout, UITextViewDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
    
    lazy var element: PublishTopicEelement = {
        return self.layoutElement()
    }()
    
    var publishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "发布")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        publishButton = self.makeNavBarRightTextItem(text: "发布")

        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.title <~ element.titleTextField.reactive.continuousTextValues.skipNil()
        
        element.contentTextView.delegate = self
        
        element.completeEditButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.element.contentTextView.resignFirstResponder()
        }
        
        element.photoButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.handleSelectPhoto()
        }
        
        element.selectCateButton.reactive.pressed = CocoaAction(viewModel.selectTopicCateAction)

        viewModel.selectTopicCateAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SelectTopicCateViewController(viewModel: model))
        }
        
        element.cateLabel.text = viewModel.currentType.value["name"].stringValue
        element.cateLabel.reactive.text <~ viewModel.currentType.signal.map({ (cate) -> String in
            return cate["name"].stringValue
        })
        
        publishButton.reactive.pressed = CocoaAction(viewModel.publishAction)
        
        viewModel.publishAction.values.observeValues { [weak self] (data) in
            self?.popViewController(animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        var attributeText: NSMutableAttributedString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        attributeText = attributeText.withParagraphStyle(ParaStyle.create(lineSpacing: 5)).withFont(Font.sys(size: 16))
        textView.attributedText = attributeText
        self.viewModel.contentAttributeText.value = attributeText
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.beginEditContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.finishEditContent()
    }

    func handleSelectPhoto() {
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
            self.viewModel.requestError.value = RequestError.warning(message: "无权限")
            return;
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        UIImagePickerController.isSourceTypeAvailable(sourceType)
        imagePicker.sourceType = sourceType
        self.rootPresent(viewController: imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            if let data = UIImageJPEGRepresentation(image, 0.1) {
                viewModel.uploadImageAction.apply(data).start()
                viewModel.uploadImageAction.values.observeValues({ (val) in
                    let imagePath: String = val["data"].stringValue
                    self.element.contentTextView.attributedText = self.element.contentTextView.attributedText
                        + self.imageAttachmentAttributeText(image: image, imagePath: imagePath)
                        + "\n".attributedString
                    self.viewModel.contentAttributeText.value = self.element.contentTextView.attributedText
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.element.contentTextView.becomeFirstResponder()
                    })
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageAttachmentAttributeText(image: UIImage, imagePath: String) -> NSAttributedString {
        var size: CGSize = CGSize.init(width: self.window_width - 40, height: 0)
        size.height = size.width * (image.size.height / image.size.width)
        let attachment = TopicImageAttachment()
        attachment.image = image
        attachment.bounds = CGRect.init(origin: CGPoint.zero, size: size)
        attachment.imagePath = imagePath
        return NSAttributedString.init(attachment: attachment)

    }
}
