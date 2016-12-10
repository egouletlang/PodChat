//
//  CardRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open  class CardRowView: BaseRowView {
    
    let imageView = BaseUIImageView(frame: CGRect.zero)
    let labelView = LabelRowView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(labelView)
    }
    override open func frameUpdate() {
        super.frameUpdate()
        
        let cardImageHeight = (self.model as? CardRowModel)?.imageHeight ?? 0
        let cardImageMargins = (self.model as? CardRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        self.imageView.frame = CGRect(
            x: cardImageMargins.left,
            y: cardImageMargins.top,
            width: self.contentView.bounds.width - cardImageMargins.left - cardImageMargins.right,
            height: cardImageHeight)
        self.labelView.frame = CGRect(
            x: 0,
            y: cardImageHeight + cardImageMargins.top + cardImageMargins.bottom,
            width: self.contentView.bounds.width,
            height: self.contentView.bounds.height - cardImageHeight - cardImageMargins.top - cardImageMargins.bottom)
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? CardRowModel {
            self.imageView.load(str: m.imageUrl)
            if let m = model as? LabelRowModel {
                labelView.titleLabel.numberOfLines = m.titleNumberOfLines
                labelView.titleLabel.labelInformation = m.title
                labelView.subTitleLabel.numberOfLines = m.subTitleNumberOfLines
                labelView.subTitleLabel.labelInformation = m.subTitle
                labelView.detailsLabel.numberOfLines = m.detailsNumberOfLines
                labelView.detailsLabel.labelInformation = m.details
            }
        }
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        
        let labelSize = labelView.getDesiredSize(model: model, forWidth: w)
        let cardImageHeight = (model as? CardRowModel)?.imageHeight ?? 0
        let cardImageMargins = (model as? CardRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        return CGSize(width: w,
                      height: labelSize.height + cardImageHeight + cardImageMargins.top + cardImageMargins.bottom)
        
    }
    
}
