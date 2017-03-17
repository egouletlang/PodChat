//
//  RHSChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

class RHSChatCVCell: BaseChatCVCell {
    
    override open func chatBubbleFrame(model: BaseChatModel) -> CGRect {
        return CGRect(x: self.frame.width - self.status.frame.width - 5 - model.size.width, y: 0, width: model.size.width, height: model.size.height)
    }
    
    override open func chatBubbleBkgColor() -> UIColor {
        return UIColor(argb: 0x7BC7B9)
    }
    
    override func getPadding(model: BaseChatModel) -> CGFloat {
        return model.hasText ? super.getPadding(model: model) : 0
    }
    
    override func setData(model: BaseChatModel) {
        super.setData(model: model)
        self.status.isHidden = model.status != .Sent
    }
    
}
