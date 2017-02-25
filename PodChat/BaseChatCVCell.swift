//
//  BaseChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

private let MAX_WIDTH: CGFloat = 260
private let STATUS_SIZE: CGFloat = 20
private let PADDING: CGFloat = 5

open class BaseChatCVCell: UICollectionViewCell, BaseRowViewDelegate, BaseUILabelDelegate {
    
    //MARK: - Constructors -
    open class func build(model: BaseChatModel) -> BaseChatCVCell {
        if model.isLhs() {
            return LHSChatCVCell(frame: CGRect.zero)
        } else {
            return RHSChatCVCell(frame: CGRect.zero)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI -
    open let chatBubble = BaseUIView(frame: CGRect.zero)
    open let status = BaseUIImageView(frame: CGRect.zero)
    
    //MARK: - CreateLayout -
    open func createLayout() {
        self.contentView.addSubview(chatBubble)
        
        chatBubble.layer.cornerRadius = 15
        chatBubble.backgroundColor = self.chatBubbleBkgColor()
        chatBubble.passThroughDefault = true
        chatBubble.clipsToBounds = true
        
        self.contentView.addSubview(status)
        status.layer.cornerRadius = STATUS_SIZE / 2
        status.loadAsset(name: "sent_indicator")
        status.isHidden = true
    }
    
    //MARK: - BaseChatViewDelegate -
    open weak var baseChatViewDelegate: BaseChatCVCellDelegate?
    
    open weak var baseUILabelDelegate: BaseUILabelDelegate?
    public func interceptUrl(_ url: URL) -> Bool {
        return self.baseUILabelDelegate?.interceptUrl?(url) ?? false
    }
    public func active() {
        self.baseUILabelDelegate?.active?()
    }
    public func inactive() {
        self.baseUILabelDelegate?.inactive?()
    }
    
    //MARK: - LHS vs RHS methods -
    open func chatBubbleBkgColor() -> UIColor {
        return UIColor.white
    }
    
    open func chatBubbleFrame(model: BaseChatModel) -> CGRect {
        return CGRect.zero
    }
    open func chatStatusFrame(model: BaseChatModel) -> CGRect {
        return CGRect(x: self.frame.width - STATUS_SIZE, y: self.frame.height - STATUS_SIZE, width: STATUS_SIZE, height: STATUS_SIZE)
    }
    
    //MARK: - Helper Methods -
    private func getCells(models: [BaseRowModel]) -> [BaseRowView] {
        return models.map() { (model) in
            let row = BaseRowModel.build(id: model.getId())
            row.baseRowViewDelegate = self
            row.baseUILabelDelegate = self
            return row
        }
    }
    
    //MARK: - Data Methods -
    open override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.chatBubble.subviews {
            view.removeFromSuperview()
        }
    }
    open func setData(model: BaseChatModel) {
        let cells = self.getCells(models: model.models)
        if cells.count > 1 {
            let container = UIView(frame: CGRect.zero)
            container.clipsToBounds = true
            container.layer.cornerRadius = 5
            container.backgroundColor = UIColor.white
            self.chatBubble.addSubview(container)
            container.frame = CGRect(x: 8,
                                     y: (model.models.first?.height ?? 0) + 8,
                                     width: model.size.width - 16,
                                     height: model.size.height - ((model.models.first?.height ?? 0) + 16))
        }
        
        let containerSize = model.size
        var height: CGFloat = 8
        for (cell, model) in zip(cells, model.models) {
            cell.setData(model: model)
            cell.frame = CGRect(x: 8, y: height, width: containerSize.width - 16, height: model.height)
            height += model.height
            self.chatBubble.addSubview(cell)
        }
        
        self.status.frame = self.chatStatusFrame(model: model)
        self.chatBubble.frame = self.chatBubbleFrame(model: model)
        
        
        
    }
    open func updateSize(model: BaseChatModel) {
        model.models = model.models.map() { $0.withPadding(l: 0, t: 0, r: 0, b: 0) }
        
        let availWidth = MAX_WIDTH - 16
        
        let cells = self.getCells(models: model.models)
        
        // first pass to find max width
        var reqWidth: CGFloat = 0
        
        for (cell, model) in zip(cells, model.models) {
            let size = cell.getDesiredSize(model: model, forWidth: availWidth)
            reqWidth = (reqWidth > size.width) ? reqWidth : size.width
        }
        
        var height: CGFloat = 0
        for (cell, model) in zip(cells, model.models) {
            model.height = cell.getDesiredSize(model: model, forWidth: reqWidth).height
            height += model.height
        }
        model.setSize(size: CGSize(width: reqWidth + 16, height: height + 16))
    }
    
    //MARK: - BaseRowViewDelegate Methods -
    public func active(view: BaseRowView) {
        self.baseChatViewDelegate?.active(view: view)
    }
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        self.baseChatViewDelegate?.tapped(model: model, view: view)
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseChatViewDelegate?.longPressed(model: model, view: view)
    }
    public func submitArgsValidityChanged(valid: Bool) {}
    public func submitArgsChanged() {}
    
}
