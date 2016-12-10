//
//  CardRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "CardRowModel"
open class CardRowModel: LabelRowModel {
 
    override open func getId() -> String {
        return ID
    }
    
    open class func isCardRowModel(id: String) -> Bool {
        return id == ID
    }
    
    override public init() {
        super.init()
        self.titleNumberOfLines = 2
        self.subTitleNumberOfLines = 1
        self.detailsNumberOfLines = 8
    }
    
    open var imageUrl: String?
    open var imageHeight: CGFloat = 0
    open var imageMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func with(imageMargins m: Rect<CGFloat>?) -> CardRowModel {
        self.set(imageMargins: m)
        return self
    }
    open func withImage(url: String?) -> CardRowModel {
        self.setImageTo(url: url)
        return self
    }
    open func set(imageMargins m: Rect<CGFloat>?) {
        self.imageMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    open func setImageTo(url: String?) {
        self.imageUrl = url
        self.imageHeight = (url != nil) ? 180 : 0
        self.imageMargins = Rect<CGFloat>(0, 0, 0, (url != nil) ? 10 : 0)
    }
    
    override open func setDetails(labelInfo li: LabelInformation) {
        self.details = li
        if li.attr != nil {
            self.setDetails(margins: Rect<CGFloat>(0, 10, 0, 0))
        }
    }
    
    override open func withDefaultBottomBorder() -> BaseRowModel {
        self.setBottomBorderTo(show: true, padding: Rect<CGFloat>(0, 0, 0, 0))
        return self
    }
    
}
