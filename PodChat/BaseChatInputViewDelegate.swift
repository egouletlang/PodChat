//
//  BaseChatInputViewDelegate.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public protocol BaseChatInputViewDelegate: NSObjectProtocol {
    func submit(text: String)
}
