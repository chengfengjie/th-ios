//
//  ShareUtil.swift
//  th-ios
//
//  Created by chengfj on 2018/3/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ShareUtil {
    
    class func registerShareInfo() {
        let types: [Any] = [
            NSNumber.init(value: SSDKPlatformType.typeQQ.rawValue),
            NSNumber.init(value: SSDKPlatformType.typeWechat.rawValue)
        ];
        
        ShareSDK.registerActivePlatforms(types , onImport: { (platformType) in
            switch platformType {
            case .typeQQ:
                ShareSDKConnector.connectQQ(
                    QQApiInterface.classForCoder(),
                    tencentOAuthClass: TencentOAuth.classForCoder())
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            default:
                break
            }
        }) { (platformType, dict) in
            switch platformType {
            case .typeQQ:
                dict?.ssdkSetupQQ(byAppId: ShareInfo.qqAppId, appKey: ShareInfo.qqAppKey, authType: SSDKAuthTypeBoth)
            case .typeWechat:
                dict?.ssdkSetupWeChat(byAppId: ShareInfo.wxAppId, appSecret: ShareInfo.wxAppSecret)
            default:
                break
            }
        }
    }
        
    class func buildShareWxImageParams(image: UIImage) -> NSMutableDictionary {
        let params: NSMutableDictionary = NSMutableDictionary()
        params.ssdkSetupShareParams(byText: "",
                                    images: NSArray.init(object: image),
                                    url: URL.init(string: ShareInfo.recommendUrl),
                                    title: "童伙妈妈",
                                    type: SSDKContentType.image)
        return params
    }
    
    class func buildShareCallBackHandler(type: SSDKPlatformType) -> SSDKShareStateChangedHandler {
        return { (res, info, entity, error) in
            switch res {
            case .begin:
                print("begin")
            case .beginUPLoad:
                print("beginUPLoad")
            case .cancel:
                print("cancel")
            case .fail:
                print("fail")
            case .success:
                print("success")
            }
        }
    }
    
    class func shareToWxTimelineImage(image: UIImage) {
        let params = buildShareWxImageParams(image: image)
        let hanlder = buildShareCallBackHandler(type: SSDKPlatformType.subTypeWechatTimeline)
        ShareSDK.share(SSDKPlatformType.subTypeWechatTimeline, parameters: params, onStateChanged: hanlder)
    }
    
    class func shareToWxFriendImage(image: UIImage) {
        let params = buildShareWxImageParams(image: image)
        let hanlder = buildShareCallBackHandler(type: SSDKPlatformType.subTypeWechatSession)
        ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: params, onStateChanged: hanlder)
    }
    
    class func shareToQQFriendImage(image: UIImage) {
        let params = buildShareWxImageParams(image: image)
        let hanlder = buildShareCallBackHandler(type: SSDKPlatformType.subTypeQQFriend)
        ShareSDK.share(SSDKPlatformType.subTypeQQFriend, parameters: params, onStateChanged: hanlder)
    }
    
    class func shareToSystemMore() {
        let vc = UIActivityViewController.init(
            activityItems: ["童伙妈妈", URL.init(string: ShareInfo.appstoreUrl)!],
            applicationActivities: nil)
        vc.excludedActivityTypes = [
            .copyToPasteboard,
            .postToWeibo,
            .postToTencentWeibo
        ]
        AppDelegate.rootNavgationController?.present(vc, animated: true, completion: nil)
    }
    
}
