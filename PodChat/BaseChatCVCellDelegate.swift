//
//  BaseChatViewDelegate.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

public protocol BaseChatCVCellDelegate: NSObjectProtocol {
    func active(view: BaseRowView)
    func tapped(model: BaseRowModel, view: BaseRowView)
    func longPressed(model: BaseRowModel, view: BaseRowView)
}
