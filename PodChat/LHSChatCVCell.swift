//
//  LHSChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

class LHSChatCVCell: BaseChatCVCell {
    
    override func createLayout() {
        super.createLayout()
        self.status.isHidden = true
    }
    
    override open func chatBubbleFrame(model: BaseChatModel) -> CGRect {
        return CGRect(x: 10, y: 0, width: model.size.width, height: model.size.height)
    }
    
    override func getPadding(model: BaseChatModel) -> CGFloat {
        return model.hasText ? super.getPadding(model: model) : 0
    }
    
    override open func chatBubbleBkgColor() -> UIColor {
        return UIColor(argb: 0xF8F8F8)
    }
    
}
