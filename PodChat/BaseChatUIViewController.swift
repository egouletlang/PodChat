//
//  BaseChatUIViewController.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI
import BaseUtils

open class BaseChatUIViewController: BaseUIViewController, BaseChatViewDelegate, BaseChatCVCellDelegate, BaseUILabelDelegate {
    
    open func createConfig() -> BaseUIViewConfig {
        return BaseChatViewConfig()
    }
    
    open var chatView: BaseChatView!
    
    override open func createLayout() {
        super.createLayout()
        
        chatView = BaseChatView(config: self.createConfig())
        
        self.view.addSubview(chatView)
        chatView.baseUIViewDelegate = self
        chatView.baseChatViewDelegate = self
        chatView.baseUILabelDelegate = self
        chatView.baseChatCVCellDelegate = self
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
        self.chatView.frame = CGRect(x: 0, y: self.effectiveTopLayoutGuide,
                                     width: self.view.frame.width,
                                     height: self.effectiveBottomLayoutGuide - self.effectiveTopLayoutGuide)
    }
    
    open override func shouldRespondToKeyboard() -> Bool {
        return true
    }
    
    open func active(view: BaseRowView) {}
    open func tapped(model: BaseRowModel, view: BaseRowView) {}
    open func longPressed(model: BaseRowModel, view: BaseRowView) {}
    
}
