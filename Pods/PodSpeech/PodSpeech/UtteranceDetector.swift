//
//  UtteranceDetector.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import BaseUtils

open class UtteranceDetector: BaseSpeechRecognitionHelper {
    
    open var delay: TimeInterval = 1
    open var partialUtterances = true
    
    open override func config() {
        super.config()
        self.shouldReportPartialResults = true
    }
    
    private lazy var queryTimer: SimpleTimer<String> = {
        var timer = SimpleTimer<String>(delay: self.delay)
        timer.fire = { [weak self] (word: String?) in
            self?.stop()
            self?.speechRecognitionHelperDelegate?.SRH_newText?(text: word, final: true)
        }
        return timer
    }()
    
    open override func newText(text: String?) {
        queryTimer.start(value: text)
        if partialUtterances {
            self.speechRecognitionHelperDelegate?.SRH_newText?(text: text, final: false)
        }
    }
    
    
}
