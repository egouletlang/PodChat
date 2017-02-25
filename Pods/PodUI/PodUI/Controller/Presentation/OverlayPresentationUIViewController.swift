//
//  OverlayPresentationUIViewController.swift
//  Wand
//
//  Created by Etienne Goulet-Lang on 10/6/15.
//  Copyright © 2015 Heine Frifeldt. All rights reserved.
//

import Foundation
import BaseUtils

open class OverlayPresentationUIViewController: BaseUIViewController {
    
    //MARK: - Navigation Items Callbacks -
    open func cancelTapped() {
        ThreadHelper.checkedExecuteOnMainThread(){
            if let nav = self.navigationController as? OverlayUINavigationController {
                nav.cleanOrSave()
                nav.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - BaseUIViewController overrides -
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        declareSize()
    }
    
    override open func viewWillLayoutSubviews() {
        if let nav = self.navigationController as? OverlayUINavigationController,
            let size = nav.getContentFrameSize() {
            self.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Layout -
    
    open var requiredSize: CGSize? {
        didSet {
            if sameSize(requiredSize, oldValue) { return }
            self.declareSize()
        }
    }

    open func setSizeIfLarger(size: CGSize) {
        if let (update, newSize) = (self.navigationController as? OverlayUINavigationController)?.isLargerSizeRequired(size: size) {
            if update {
                self.requiredSize = newSize
            }
        } else {
            self.requiredSize = size
        }
    }
    
    open func declareSize() {
        if let nav = self.navigationController as? OverlayUINavigationController,
            let reqSize = requiredSize {
                if reqSize.equalTo(CGSize.zero) {
                    nav.setNoRequiredSize()
                } else {
                    nav.setRequiredSize(size: reqSize)
                }
        }
    }
    

    
    
    // MARK: - Private helpers -
    
    private func sameSize(_ oldValue: CGSize?,_ newValue: CGSize?) -> Bool {
        return (oldValue != nil && newValue != nil && oldValue!.equalTo(newValue!)) ||
            (oldValue == nil && newValue == nil)
    }
    
    
}
