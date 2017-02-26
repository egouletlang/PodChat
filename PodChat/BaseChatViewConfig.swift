//
//  BaseChatViewConfig.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

open class BaseChatViewConfig: BaseUIViewConfig {
    
    open var sendBarPrompt = "Say Something"
    
    open var sendButtonBackgroundColor = UIColor(argb: 0x7B868C)
    
    open var sendIconAsset = ""
    
    open var allowAudio = true
    open var audioIconAsset = ""
    open var audioAutoSend = true
    
}
