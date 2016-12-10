//
//  BaseUITextField.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class BaseUITextField: UITextField {
    
    private var mayResign = true
    open func setDisallowResign() {
        mayResign = false
    }
    
    open func setAllowResign() {
        mayResign = true
    }
    
    override open var canResignFirstResponder: Bool {
        get {
            return mayResign
        }
    }
    
}
