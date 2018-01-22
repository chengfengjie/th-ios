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

protocol CarouselTableHeaderProtocol {
    var tableNodeHeader: CarouseTableNodeHeader { get }
}

extension CarouselTableHeaderProtocol where Self: BaseTableViewController {
    
    var carouseBounds: CGRect {
        let proportion: CGFloat = 1.0 / 2.0
        let height: CGFloat = self.window_width * proportion
        return CGRect.init(x: 0, y: 0, width: self.window_width, height: height)
    }
    
    private var testImageArray: [URL] {
        if let url = URL.init(string: "http://a.hiphotos.baidu.com/image/pic/item/500fd9f9d72a6059f550a1832334349b023bbae3.jpg") {
            return [url]
        }
        return []
    }
    
    func makeCarouseHeaderBox() -> CarouseTableNodeHeader {
        
        let container: UIView = UIView()
        container.frame = self.self.carouseBounds
        
        let configBlock: CarouselConfigurationBlock = { (make:JYConfiguration?) -> JYConfiguration? in
            return make
        }
        
        let clickBlock = { (index: Int) in
            
        }
        
        let carouselView: JYCarousel = JYCarousel.init(frame: self.carouseBounds,
                                                       configBlock: configBlock,
                                                       click: clickBlock)
        
        container.addSubview(carouselView)
        
        carouselView.start(with: NSMutableArray.init(array: self.testImageArray))
        
        return CarouseTableNodeHeader.init(container: container, carouse: carouselView)
    }
    
}
