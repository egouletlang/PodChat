//
//  BaseChatCVCell.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

private let MAX_WIDTH: CGFloat = 300
private let STATUS_SIZE: CGFloat = 20
private let PADDING: CGFloat = 5

open class BaseChatCVCell: UICollectionViewCell, BaseRowViewDelegate {
    
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
        
        self.contentView.addSubview(status)
        status.layer.cornerRadius = 10
        status.backgroundColor = UIColor.blue
    }
    
    //MARK: - BaseChatViewDelegate -
    open weak var baseChatViewDelegate: BaseChatCVCellDelegate?
    
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
        return models.map() { BaseRowModel.build(id: $0.getId()) }
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
            container.frame = CGRect(x: 5,
                                     y: (model.models.first?.height ?? 0) + 5,
                                     width: model.size.width,
                                     height: model.size.height - (model.models.first?.height ?? 0) + 5)
        }
        
        let containerSize = model.size
        var height: CGFloat = 5
        for (cell, model) in zip(cells, model.models) {
            cell.setData(model: model)
            cell.frame = CGRect(x: 5, y: height, width: model.height, height: containerSize.width)
            height += model.height
            self.chatBubble.addSubview(cell)
        }
        
        
    }
    open func updateSize(model: BaseChatModel) {
        let availWidth = MAX_WIDTH
        
        let cells = self.getCells(models: model.models)
        
        // first pass to find max width
        var reqWidth: CGFloat = 0
        
        for (cell, model) in zip(cells, model.models) {
            let size = cell.getDesiredSize(model: model, forWidth: availWidth)
            reqWidth = (reqWidth > size.width) ? reqWidth : size.width
        }
        
        let height = zip(cells, model.models).reduce(0) {$0 + $1.0.getDesiredSize(model: $1.1, forWidth: reqWidth).height }
        model.setSize(size: CGSize(width: reqWidth + 10, height: height + 10))
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
