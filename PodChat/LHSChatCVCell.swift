//
//  LHSChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

class LHSChatCVCell: BaseChatCVCell {
    
    override open func chatBubbleFrame(model: BaseChatModel) -> CGRect {
        return CGRect(x: 25, y: 0, width: model.size.width, height: model.size.height)
    }
    
    override open func chatBubbleBkgColor() -> UIColor {
        return UIColor(argb: 0xC3C3C3)
    }
    
}
