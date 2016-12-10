//
//  BaseChatInputView.swift
//  PodChat
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodUI
import BaseUtils

open class BaseChatInputView: BaseUIView, UITextFieldDelegate {
    private let input = BaseUITextField(frame: CGRect.zero)
    private let submit = BaseUIImageView(frame: CGRect.zero)
    
    open func dismiss() {
        input.resignFirstResponder()
    }
    
    open weak var baseChatInputViewDelegate: BaseChatInputViewDelegate?
    
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.addSubview(input)
        input.layer.cornerRadius = 10
        input.placeholder = "Say Something"
        input.delegate = self
        input.backgroundColor = UIColor.white
        input.returnKeyType = .send
        self.addSubview(submit)
        submit.layer.cornerRadius = 10
        self.addTap(submit, selector: #selector(BaseChatInputView.submitText))
        submit.backgroundColor = UIColor.black
    }
    
    open override func frameUpdate() {
        super.frameUpdate()
        input.frame = CGRect(x: 8, y: 8, width: self.frame.width - 24 - 20, height: self.frame.height - 16)
        submit.frame = CGRect(x: self.frame.width - 28, y: (self.frame.height - 20) / 2, width: 20, height: 20)
    }
    
    open func submitText() {
        let text = self.input.text
        self.input.text = nil
        ThreadHelper.executeOnBackgroundThread {
            if let t = text {
                self.baseChatInputViewDelegate?.submit(text: t)
            }
        }
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        submitText()
        return true
    }
    
}
