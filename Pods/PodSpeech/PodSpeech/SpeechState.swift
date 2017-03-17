//
//  SpeechState.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import BaseUtils

private let DEFAULT_LOCALE = "en-US"

open class SpeechState: BaseState {
    
    private let LOCALE_KEY = "key.locale"
    
    open static let instance = SpeechState()
    
    override open func getFiletName() -> String {
        return "SPEECH-STATE"
    }
    
    open var locale: String {
        get { return getValue(key: LOCALE_KEY, DEFAULT_LOCALE)! }
        set { setValue(key: LOCALE_KEY, newValue) }
    }
}
