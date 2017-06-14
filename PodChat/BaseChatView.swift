//
//  BaseChatView.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI
import BaseUtils

private class QRUICollectionReusableView: UICollectionViewCell {
    
}

private let DEFAULT_INSETS = UIEdgeInsetsMake(3, 5, 3, 5)
open class BaseChatView: BaseUIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseChatCVCellDelegate, BaseChatInputViewDelegate, BaseUILabelDelegate, BaseRowViewDelegate, QuickReplyCollectionDelegate {
    
    open weak var baseChatViewDelegate: BaseChatViewDelegate?
    open weak var baseChatCVCellDelegate: BaseChatCVCellDelegate?
    
    private var collectionView: BaseUICollectionView!
    private var chatTypeStatus = BaseUIImageView(frame: CGRect.zero)
    private var chatInputVIew: BaseChatInputView!
    private var quickRepliesView = QuickReplyCollection(frame: CGRect.zero)
    private var models = [BaseChatModel]()
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.backgroundColor = UIColor(argb: 0xCC444444)
        
        let layout = BaseUICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = CGSize(width: 0, height: 40)
        
        collectionView = BaseUICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(LHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "LHS")
        collectionView.register(RHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "RHS")
        collectionView.register(CarouselChatCVCell.classForCoder(), forCellWithReuseIdentifier: "SCROLL")
        
        collectionView.register(QRUICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "QR")
        
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let contentInsets = DEFAULT_INSETS
        self.collectionView?.contentInset = contentInsets
        
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        self.addTap(collectionView, selector: #selector(BaseChatView.dismissKeyboard))
        
        chatTypeStatus.setContentMode(contentMode: .scaleAspectFit)
        chatTypeStatus.loadAsset(name: "sending_indicator")
        chatTypeStatus.alpha = 0
        
//        self.addSubview(quickRepliesView)
        
        chatInputVIew = BaseChatInputView(config: self.config)
        self.addSubview(chatInputVIew)
        chatInputVIew.backgroundColor = UIColor(argb: 0xFFFFFF)
        chatInputVIew.baseChatInputViewDelegate = self
        
        quickRepliesView.quickReplyCollectionDelegate = self
        quickRepliesView.backgroundColor = UIColor.clear
        quickRepliesView.alpha = 1
        self.addTap(quickRepliesView, selector: #selector(BaseChatView.dismissKeyboard))
        
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
        self.chatInputVIew.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 50)
        self.quickRepliesView.frame = CGRect(x: -10, y: 0, width: self.frame.width - 10, height: 40)
        self.chatTypeStatus.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 50)
        
        (self.collectionView.collectionViewLayout as? BaseUICollectionViewFlowLayout)?.footerReferenceSize.width = self.frame.width
        
        collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let model = models.get(indexPath.item),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.getId(), for: indexPath) as? BaseChatCVCell {
            
            cell.baseChatViewDelegate = self
            cell.baseUILabelDelegate = self
            cell.setData(model: model)
            
            return cell
        }
        return UICollectionViewCell()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = models.get(indexPath.item) {
            return CGSize(width: self.frame.width - DEFAULT_INSETS.left - DEFAULT_INSETS.right,
                          height: model.size.height)
        }
        
        return CGSize(width: 2, height: 2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                                           withReuseIdentifier: "QR", for: indexPath) as! UICollectionViewCell
        reusableview.contentView.clipsToBounds = true
        
        chatTypeStatus.removeFromSuperview()
        reusableview.contentView.addSubview(chatTypeStatus)
        
        
        if (self.config as? BaseChatViewConfig)?.showQuickReplies ?? true {
            quickRepliesView.removeFromSuperview()
            reusableview.contentView.addSubview(quickRepliesView)
        }
        
        return reusableview
    }
    
    open func addModel(model: BaseChatModel) {
        ThreadHelper.checkedExecuteOnMainThread {
            BaseChatCVCell.build(model: model).updateSize(model: model, width: self.frame.width)
            
            print(self.models.count)
            let indexPath = IndexPath(row: self.models.count, section: 0)
            print(indexPath)
            
            self.models.append(model)
            print(self.models.count)
            self.collectionView.insertItems(at: [indexPath])
            
            if self.collectionView.contentSize.height > self.collectionView.frame.height {
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                self.collectionView.contentOffset.y += 40
            }
        }
    }
    
    open func addServerMessage(text: String?, models: [BaseRowModel]?) {
        if (text == nil && (models == nil || models!.isEmpty)) { return }
        
        if (models?.first as? CarouselRowModel) != nil {
            self.addModel(model: BaseChatModel.buildCarousel(models: models))
        } else {
            self.addModel(model: BaseChatModel.buildServerMessage(text: text, models: models))
        }
        
    }
    open func addUserMessage(text: String?, models: [BaseRowModel]?) {
        if (text == nil && (models == nil || models!.isEmpty)) { return }
        
        if (models?.first as? CarouselRowModel) != nil {
            self.addModel(model: BaseChatModel.buildCarousel(models: models))
        } else {
            self.addModel(model: BaseChatModel.buildUserMessage(text: text, models: models))
        }
        
    }
    open func addUI(models: [BaseRowModel]?) {
        if ((models == nil || models!.isEmpty)) { return }
        self.addModel(model: BaseChatModel.buildCarousel(models: models))
    }
    
    open func messageSent(indexPath: IndexPath) {
        if let model = models.get(indexPath.item) {
            model.status = .Sent
        }
        if let cell = self.collectionView.cellForItem(at: indexPath) as? RHSChatCVCell {
            cell.status.isHidden = false
        }
    }
    
    public func active(view: BaseRowView) {
        self.baseChatCVCellDelegate?.active(view: view)
    }
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        self.baseChatCVCellDelegate?.tapped(model: model, view: view)
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseChatCVCellDelegate?.longPressed(model: model, view: view)
    }
    public func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {}
    
    public func dismissKeyboard() {
        self.chatInputVIew.dismiss()
    }
    
    public func submit(text: String) {
        self.submit(text: text, displayText: text)
    }
    
    public func submit(text: String, displayText: String) {
        if (text.isEmpty) {
            return
        }
        
        let indexPath = IndexPath(row: self.models.count, section: 0)
        self.addUserMessage(text: displayText, models: nil)
        self.baseChatViewDelegate?.send?(text: text, index: indexPath)
    }
    
    public func audio(on: Bool) {
        self.baseChatViewDelegate?.audio?(on: on)
    }
    
    open func showTyping(show: Bool) {
        let offset: CGFloat = (show) ? 0 : 40
        ThreadHelper.executeOnMainThread {
            
//            UIView.animate(withDuration: 0.3) {
//                self.chatTypeStatus.frame.origin.y = offset
//                self.quickRepliesView.frame.origin.y = 40 - offset
//                
//            }
            UIView.animate(withDuration: 0.3) {
                self.chatTypeStatus.alpha = show ? 1 : 0
                self.quickRepliesView.alpha = show ? 0 : 1
                
            }
//            if show {
//                self.collectionView.contentOffset.y += 40
//            }
            //            }
        }
        print("offset \(offset)")
    }
    
    func changeFrames() {
        
    }
    
    open func addQuickReplies(qrs: [QuickReply]) {
        self.quickRepliesView.setModels(models: qrs.flatMap() { (qr: QuickReply) -> BaseRowModel? in
            
            var model = ImageLabelRowModel()
                .with(lhsImage: qr.icon)
                .with(lhsCircle: true)
                .with(lhsSize: CGSize(width: qr.icon != nil ? 30 : 0, height: 30))
            
            
            if qr.icon != nil && qr.title != nil {
                model = model
                    .with(lhsMargins: Rect<CGFloat>(0, 0, 3, 0))
                    .with(rhsMargins: Rect<CGFloat>(10, 0, 0, 0))
            } else if qr.icon != nil {
                model = model
                    .with(lhsMargins: Rect<CGFloat>(0, 0, 0, 0))
                    .with(rhsMargins: Rect<CGFloat>(0, 0, 0, 0))
            } else {
                model = model
                    .with(lhsMargins: Rect<CGFloat>(0, 0, 5, 0))
                    .with(rhsMargins: Rect<CGFloat>(5, 0, 0, 0))
            }
            return model
                .withTitle(str: qr.title)
                .withPadding(l: 0, t: 0, r: 0, b: 0)
                .withBackgroundColor(color: UIColor.clear)
                .withBorderColor(color: UIColor.red)
                .withCornerRadius(radius: 15)
                .withClickResponse(obj: qr)
        })
    }
    
    //MARK: - BaseUILabelDelegate Methods -
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
    public func quickReply(model: BaseRowModel, view: BaseRowView) {
        if let qr = model.clickResponse as? QuickReply {
            
            if let postback = qr.postback {
                self.submit(text: postback)
            }
            qr.callback(qr)
            self.quickRepliesView.setModels(models: [])
        }
    }
    
}
