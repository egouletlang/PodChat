//
//  BaseChatViewDelegate.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public protocol BaseChatViewDelegate: NSObjectProtocol {
    func send(text: String, index: IndexPath)
}
