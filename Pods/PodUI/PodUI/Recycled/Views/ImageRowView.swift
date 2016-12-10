//
//  ImageRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class ImageRowView: BaseRowView {
    
    open let imageView = BaseUIImageView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    override open func frameUpdate() {
        super.frameUpdate()
        
        let cardImageHeight = (self.model as? ImageRowModel)?.imageHeight ?? self.contentView.frame.width
        let cardImageMargins = (self.model as? ImageRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        self.imageView.frame = CGRect(
            x: cardImageMargins.left,
            y: cardImageMargins.top,
            width: self.contentView.bounds.width - cardImageMargins.left - cardImageMargins.right,
            height: cardImageHeight)
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? CardRowModel {
            self.imageView.load(str: m.imageUrl)
        }
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        
        let cardImageHeight = (model as? CardRowModel)?.imageHeight ?? w
        let cardImageMargins = (model as? CardRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        return CGSize(width: w,
                      height: cardImageHeight + cardImageMargins.top + cardImageMargins.bottom)
        
    }
    
}
