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

private let DEFAULT_INSETS = UIEdgeInsetsMake(3, 5, 3, 5)
open class BaseChatView: BaseUIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseChatCVCellDelegate, BaseChatInputViewDelegate, BaseUILabelDelegate {
    
    open weak var baseChatViewDelegate: BaseChatViewDelegate?
    open weak var baseChatCVCellDelegate: BaseChatCVCellDelegate?
    
    private var collectionView: BaseUICollectionView!
    private var chatTypeStatus = BaseUIImageView(frame: CGRect.zero)
    private var chatInputVIew: BaseChatInputView!
    private var models = [BaseChatModel]()
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.backgroundColor = UIColor(argb: 0xCC444444)
        
        let layout = BaseUICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
        collectionView = BaseUICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(LHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "LHS")
        collectionView.register(RHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "RHS")
        
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let contentInsets = DEFAULT_INSETS
        self.collectionView?.contentInset = contentInsets
        
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        self.addTap(collectionView, selector: #selector(BaseChatView.dismissKeyboard))
        
        self.addSubview(chatTypeStatus)
        chatTypeStatus.setContentMode(contentMode: .scaleAspectFit)
        chatTypeStatus.loadAsset(name: "sending_indicator")
        
        chatInputVIew = BaseChatInputView(config: self.config)
        self.addSubview(chatInputVIew)
        chatInputVIew.backgroundColor = UIColor(argb: 0xFFFFFF)
        chatInputVIew.baseChatInputViewDelegate = self
        
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
        self.chatInputVIew.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 50)
        self.chatTypeStatus.frame = CGRect(x: 0, y: self.frame.height - 50, width: 80, height: 40)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 50)
        
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
    
    open func addModel(model: BaseChatModel) {
        BaseChatCVCell().updateSize(model: model)
        ThreadHelper.checkedExecuteOnMainThread {
            let indexPath = IndexPath(row: self.models.count, section: 0)
            
            self.models.append(model)
            self.collectionView.insertItems(at: [indexPath])
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    open func addServerMessage(text: String?, models: [BaseRowModel]?) {
        if (text == nil && (models == nil || models!.isEmpty)) { return }
        self.addModel(model: BaseChatModel.buildServerMessage(text: text, models: models))
    }
    open func addUserMessage(text: String?, models: [BaseRowModel]?) {
        if (text == nil && (models == nil || models!.isEmpty)) { return }
        self.addModel(model: BaseChatModel.buildUserMessage(text: text, models: models))
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
    
    public func dismissKeyboard() {
        self.chatInputVIew.dismiss()
    }
    
    public func submit(text: String) {
        if (text.isEmpty) {
            return
        }
        
        let indexPath = IndexPath(row: self.models.count, section: 0)
        self.addUserMessage(text: text, models: nil)
        self.baseChatViewDelegate?.send?(text: text, index: indexPath)
    }
    public func audio(on: Bool) {
        self.baseChatViewDelegate?.audio?(on: on)
    }
    
    open func showTyping(show: Bool) {
        ThreadHelper.executeOnMainThread {
            
            UIView.animate(withDuration: 0.3) {
                if (show) {
                    self.chatTypeStatus.frame = CGRect(x: 0, y: self.frame.height - 90, width: 80, height: 40)
                    self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 90)
                } else {
                    self.chatTypeStatus.frame = CGRect(x: 0, y: self.frame.height - 50, width: 80, height: 40)
                    self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 50)
                }
            }
                self.collectionView.scrollToItem(at: IndexPath(item: self.models.count - 1, section: 0), at: .bottom, animated: false)
//            }
            
            
            
        }
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
    
}
