//
//  CarouselTableHeaderProtocol.swift
//  th-ios
//
//  Created by chengfj on 2018/1/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class CarouseTableNodeHeader: NSObject {
    var container: UIView
    var carouse: JYCarousel
    init(container: UIView, carouse: JYCarousel) {
        self.container = container
        self.carouse = carouse
        super.init()
    }
}

protocol CarouselTableHeaderProtocol: SizeUtil {
    var tableNodeHeader: CarouseTableNodeHeader { get }
    var css: AppStyle { get }
}

extension CarouselTableHeaderProtocol {
    
    var carouseBounds: CGRect {
        let proportion: CGFloat = self.css.home_index.bannerHWRatio.cgFloat
        let height: CGFloat = self.window_width * proportion
        return CGRect.init(x: 0, y: 0, width: self.window_width, height: height)
    }
    
    func makeCarouseHeaderBox() -> CarouseTableNodeHeader {
        
        let container: UIView = UIView()
        container.frame = self.carouseBounds
        
        let configBlock: CarouselConfigurationBlock = { (make:JYConfiguration?) -> JYConfiguration? in
            make?.placeholder = UIImage.defaultImage
            make?.contentMode = .scaleAspectFill
            return make
        }
        
        let clickBlock = { (index: Int) in
            
        }
        
        let carouselView: JYCarousel = JYCarousel.init(frame: self.carouseBounds,
                                                       configBlock: configBlock,
                                                       click: clickBlock)
        
        container.addSubview(carouselView)
        
        UIView().do {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.top.equalTo(0)
            })
            $0.backgroundColor = UIColor.black
            $0.alpha = 0.3
            $0.isUserInteractionEnabled = false
        }
        
        return CarouseTableNodeHeader.init(container: container, carouse: carouselView)
    }
    
}
