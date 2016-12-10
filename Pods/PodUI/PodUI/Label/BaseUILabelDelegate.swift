//
//  BaseUILabelDelegate.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

protocol BaseUILabelDelegate: NSObjectProtocol {
    func interceptUrl(_ url: URL)->Bool
    func active()->Void
    func inactive()->Void
}
