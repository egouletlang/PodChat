//
//  BaseChatInputViewDelegate.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

@objc
public protocol BaseChatInputViewDelegate: NSObjectProtocol {
    @objc optional func submit(text: String)
    @objc optional func audio(on: Bool)
}
