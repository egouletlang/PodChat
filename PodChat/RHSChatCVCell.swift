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
        return CGRect(x: self.frame.width - 25 - model.size.width, y: 0, width: model.size.width, height: model.size.height)
    }
    
    override open func chatBubbleBkgColor() -> UIColor {
        return UIColor(argb: 0x7BC7B9)
    }
    
}