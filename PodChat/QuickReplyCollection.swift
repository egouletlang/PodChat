//
//  QuickReplyCollection.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 3/3/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

open class QuickReply: NSObject {
    
    deinit {
        print("QUICK REPLY deinit")
    }
    
    open var title: String?
    open func withTitle(str: String?) -> QuickReply {
        self.setTitle(str: str)
        self.setPostback(str: str ?? "")
        return self
    }
    open func setTitle(str: String?) {
        self.title = str
    }
    
    open var icon: String?
    open func withIcon(str: String?) -> QuickReply {
        self.setIcon(str: str)
        return self
    }
    open func setIcon(str: String?) {
        self.icon = str
    }
    
    open var postback: String?
    open func withPostback(str: String?) -> QuickReply {
        self.setPostback(str: str)
        return self
    }
    open func setPostback(str: String?) {
        self.postback = str
    }
    
    open var callback: (QuickReply)->Void = { (_) in }
    open func withCallback(callback: @escaping (QuickReply)->Void) -> QuickReply {
        self.setCallbackTo(callback: callback)
        return self
    }
    open func setCallbackTo(callback: @escaping (QuickReply)->Void) {
        self.callback = callback
    }
}

public protocol QuickReplyCollectionDelegate: NSObjectProtocol {
    func quickReply(model: BaseRowModel, view: BaseRowView)
}

open class QuickReplyCollection: BaseUICollection {
    
    open weak var quickReplyCollectionDelegate: QuickReplyCollectionDelegate?
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.collectionView?.contentInset = UIEdgeInsetsMake(2, 2, 2, 2)
    }
    
    override open func getBackgroundColor() -> UIColor {
        return UIColor.clear
    }
    override open func getLineSpacing() -> CGFloat {
        return 1
    }
    override open func getItemSpacing() -> CGFloat {
        return 5
    }
    override open func getScrollDirection() -> UICollectionViewScrollDirection {
        return .horizontal
    }
    
    override open func createCollectionViewCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = super.createCollectionViewCell(collectionView, cellForItemAt: indexPath)
        collectionViewCell.transform = CGAffineTransform(scaleX: -1, y: 1)
        return collectionViewCell
    }
    
    override open func interceptTapped(model: BaseRowModel, view: BaseRowView) -> Bool {
        self.quickReplyCollectionDelegate?.quickReply(model: model, view: view)
        return true
    }
    
}
