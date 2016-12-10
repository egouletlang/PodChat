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

open class BaseChatUIViewController: BaseUIViewController, BaseChatViewDelegate {
    
    private let chatView = BaseChatView(frame: CGRect.zero)
    
    
    override open func createLayout() {
        super.createLayout()
        self.view.addSubview(chatView)
        chatView.baseChatViewDelegate = self
        
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
    
    public func send(text: String, index: IndexPath) {
        print("\(text) \(index)")
        ThreadHelper.delay(sec: 0.5, mainThread: true) {
            self.chatView.messageSent(indexPath: index)
        }
    }
    
}
