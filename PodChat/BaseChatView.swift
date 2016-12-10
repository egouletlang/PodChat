//
//  BaseChatView.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI

private let DEFAULT_INSETS = UIEdgeInsetsMake(3, 5, 3, 5)
open class BaseChatView: BaseUIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseChatCVCellDelegate {
    
    private var collectionView: BaseUICollectionView!
    private var models = [BaseChatModel]()
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.backgroundColor = UIColor(argb: 0xAAAAAA)
        
        let layout = BaseUICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
        collectionView = BaseUICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(LHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "LHS")
        collectionView.register(RHSChatCVCell.classForCoder(), forCellWithReuseIdentifier: "RHS")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let contentInsets = DEFAULT_INSETS
        self.collectionView?.contentInset = contentInsets
        
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        self.collectionView.frame = self.bounds
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
            cell.setData(model: model)
            
            return cell
        }
        return UICollectionViewCell()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height - DEFAULT_INSETS.top - DEFAULT_INSETS.bottom)
    }
    
    
    public func active(view: BaseRowView) {}
    public func tapped(model: BaseRowModel, view: BaseRowView) {}
    public func longPressed(model: BaseRowModel, view: BaseRowView) {}
    
}
