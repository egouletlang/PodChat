//
//  CarouselChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 3/3/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class CarouselChatCVCell: BaseChatCVCell {
    
    override open func chatBubbleFrame(model: BaseChatModel) -> CGRect {
        print(model.size.width)
        return CGRect(x: -5, y: 0, width: model.size.width + 10, height: model.size.height)
    }
    
    override open func chatBubbleCornerRadius() -> CGFloat {
        return 0
    }
    
    override open func chatBubbleBkgColor() -> UIColor {
        return UIColor.red
    }
    
    override open func getPadding(model: BaseChatModel) -> CGFloat {
        return 0
    }
    
    override open func getMaxWidth(model: BaseChatModel, width: CGFloat) -> CGFloat {
        return width 
    }
    
    override open func setData(model: BaseChatModel) {
        super.setData(model: model)
        self.status.isHidden = model.status != .Sent
    }
    
    override open func updateSize(model: BaseChatModel, width: CGFloat) {
        super.updateSize(model: model, width: width)
        model.size.width = width
    }
    
}

