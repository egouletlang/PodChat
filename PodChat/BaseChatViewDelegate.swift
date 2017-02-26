//
//  BaseChatViewDelegate.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

@objc
public protocol BaseChatViewDelegate: NSObjectProtocol {
    @objc optional func send(text: String, index: IndexPath)
    @objc optional func audio(on: Bool)
}

