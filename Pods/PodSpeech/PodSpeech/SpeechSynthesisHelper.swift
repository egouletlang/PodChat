//
//  SpeechSynthesisHelper.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import AVFoundation

open class SpeechSynthesisHelper: NSObject, AVSpeechSynthesizerDelegate {
    public override init() {
        super.init()
        synth.delegate = self
    }
    private var synth = AVSpeechSynthesizer()
    
    open weak var speechRecognitionHelperDelegate: SpeechSynthesisHelperDelegate?
    
    open func process(text: String) -> String {
        return text
    }
    
    open func say(text: String?) {
        guard let t = text else { return }
        let utterance = AVSpeechUtterance(string: self.process(text: t))
        synth.speak(utterance)
    }
    
    open func silence() {
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.speechRecognitionHelperDelegate?.SSH_speechStatus?(on: true)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.speechRecognitionHelperDelegate?.SSH_speechStatus?(on: false)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speechRecognitionHelperDelegate?.SSH_speechStatus?(on: false)
    }
    
}
