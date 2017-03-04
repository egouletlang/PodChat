//
//  BaseChatModel.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

open class BaseChatModel: NSObject {
    
    public override init() {
        super.init()
    }
    
    class func buildServerMessage(text: String?, models: [BaseRowModel]?) -> BaseChatModel {
        var respModels = models ?? []
        
        if let t = text {
            respModels.insert(LabelRowModel().withTitle(str: t), at: 0)
        }
        
        respModels = respModels.map() { $0.withBackgroundColor(color: UIColor.clear) }
        
        return BaseChatModel()
                    .withLeftHandSide(set: true)
                    .withModels(models: respModels)
    }
    class func buildUserMessage(text: String?, models: [BaseRowModel]?) -> BaseChatModel {
        var respModels = models ?? []
        
        if let t = text {
            respModels.insert(LabelRowModel().withTitle(str: t.addColor("#FFFFFF")).withBackgroundColor(color: UIColor.clear), at: 0)
        }
        
//        respModels = respModels.map() { $0.withBackgroundColor(color: UIColor.clear) }
        
        return BaseChatModel()
            .withLeftHandSide(set: false)
            .withModels(models: respModels)
    }
    
    
    public enum Status {
        case Sent
        case Sending
        case Failed
    }
    
    open var status = Status.Sending
    
    open var size = CGSize.zero
    open func withSize(size: CGSize) -> BaseChatModel {
        self.setSize(size: size)
        return self
    }
    open func setSize(size: CGSize) {
        self.size = size
    }
    
    open var isLeftHandSide = false
    open func withLeftHandSide(set: Bool) -> BaseChatModel {
        self.setLeftHandSide(set: set)
        return self
    }
    open func setLeftHandSide(set: Bool) {
        self.isLeftHandSide = set
    }
    
    open var models = [BaseRowModel]()
    open func withModels(models: [BaseRowModel]) -> BaseChatModel {
        self.setModels(models: models)
        return self
    }
    open func setModels(models: [BaseRowModel]) {
        self.models = models
    }
    
    open func isLhs() -> Bool {
        return self.isLeftHandSide
    }
    
    open func getId() -> String {
        return self.isLeftHandSide ? "LHS" : "RHS"
    }
}
