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
import PodSpeech

open class BaseChatInputView: BaseUIView, UITextFieldDelegate, SpeechRecognitionHelperDelegate {
    
    private static let INITIAL_AUDIO_TEXT = "I'm Listening"
    
    // MARK: - Initializer with a config object -
    public convenience init(config: BaseChatViewConfig) {
        self.init(frame: CGRect.zero)
        self.config = config
    }
    
    // MARK: - Speech -
    private let utteranceDetector = UtteranceDetector()
    
    // MARK: - UI -
    private let input = BaseUITextField(frame: CGRect.zero)
    private let label = BaseUILabel(frame: CGRect.zero)
    private let submit = BaseUIImageView(frame: CGRect.zero)
    
    // MARK: - Lifecycle - 
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.addSubview(input)
        input.layer.cornerRadius = 10
        input.placeholder = (config as? BaseChatViewConfig)?.sendBarPrompt ?? ""
        input.delegate = self
        input.backgroundColor = UIColor.white
        input.returnKeyType = .send
        input.addTarget(self, action: #selector(BaseChatInputView.textFieldDidChange(_:)), for: .editingChanged)
        
        self.addSubview(label)
        label.text = BaseChatInputView.INITIAL_AUDIO_TEXT
        label.textColor = UIColor.white
        label.alpha = 0
        label.backgroundColor = (config as? BaseChatViewConfig)?.sendButtonBackgroundColor ?? UIColor(argb: 0x7B868C)
        label.padding.left = 13
        label.padding.top = -2
        label.padding.right = 40
        
        self.addSubview(submit)
        self.addTap(submit, selector: #selector(BaseChatInputView.submitTapped))
        submit.layer.cornerRadius = 15
        submit.backgroundColor = (config as? BaseChatViewConfig)?.sendButtonBackgroundColor ?? UIColor(argb: 0x7B868C)
        
        self.setSendButtonImage()
        
        utteranceDetector.speechRecognitionHelperDelegate = self
    }
    
    open override func frameUpdate() {
        super.frameUpdate()
        input.frame = CGRect(x: 8, y: 8, width: self.frame.width - 24 - 25, height: self.frame.height - 16)
        label.frame = self.bounds
        submit.frame = CGRect(x: self.frame.width - 38, y: (self.frame.height - 30) / 2, width: 30, height: 30)
    }
    
    // MARK: - Resign First Responder -
    open func dismiss() {
        input.resignFirstResponder()
    }
    
    open weak var baseChatInputViewDelegate: BaseChatInputViewDelegate?
    
    open func submitTapped() {
        if self.input.hasText {
            self.submitText()
        } else if (self.config as? BaseChatViewConfig)?.allowAudio ?? false {
            self.detectUtterance()
        }
    }
    
    open func submitText() {
        let text = self.input.text
        self.input.text = nil
        self.checkButtonStatus()
        ThreadHelper.executeOnBackgroundThread {
            if let t = text {
                self.baseChatInputViewDelegate?.submit?(text: t)
            }
        }
        
    }
    
    open func detectUtterance() {
        if utteranceDetector.isAvailable() {
            utteranceDetector.authorize() { (vc: UIViewController?) in
                if vc != nil {
                    self.baseUIViewDelegate?.presentVC?(vc!, animated: true)
                } else {
                    ThreadHelper.executeOnMainThread {
                        self.label.text = BaseChatInputView.INITIAL_AUDIO_TEXT
                        
                        UIView.animate(withDuration: 0.3) {
                            self.label.alpha = 1
                        }
                        
                        ThreadHelper.executeOnBackgroundThread {
                            self.baseChatInputViewDelegate?.audio?(on: true)
                        }
                    }
                    self.utteranceDetector.start()
                }
            }
        }
    }
    
    public func SRH_newText(text: String?, final: Bool) {
        ThreadHelper.executeOnMainThread {
            self.label.text = text
            self.input.text = text
            
            if final {
                ThreadHelper.executeOnBackgroundThread {
                    self.baseChatInputViewDelegate?.audio?(on: false)
                }
                UIView.animate(withDuration: 0.3) {
                    self.label.alpha = 0
                }
                if (self.config as? BaseChatViewConfig)?.audioAutoSend ?? false {
                    self.submitText()
                } else if final {
                    self.checkButtonStatus()
                }
            }
        }
    }
    
    public func setSendButtonImage() {
        ThreadHelper.checkedExecuteOnMainThread {
            if self.input.hasText {
                self.submit.loadAsset(name: (self.config as? BaseChatViewConfig)?.sendIconAsset ?? "")
                self.submit.isHidden = false
            } else if (self.config as? BaseChatViewConfig)?.allowAudio ?? false {
                self.submit.loadAsset(name: (self.config as? BaseChatViewConfig)?.audioIconAsset ?? "")
                self.submit.isHidden = false
            } else {
                self.submit.isHidden = true
            }
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if self.input.hasText {
            submitText()
        }
        return self.input.hasText
    }
    
    private var hasText = false
    
    private func checkButtonStatus() {
        if hasText != self.input.hasText {
            hasText = self.input.hasText
            self.setSendButtonImage()
        }
    }
    
    public func textFieldDidChange(_ textField: UITextField) {
        self.checkButtonStatus()
    }
    
}
