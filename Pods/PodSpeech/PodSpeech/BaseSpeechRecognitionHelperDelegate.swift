//
//  BaseSpeechRecognitionHelperDelegate.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

@objc
public protocol SpeechRecognitionHelperDelegate: NSObjectProtocol {
    @objc optional func SRH_newText(text: String?, final: Bool)
    @objc optional func SRH_newStatus(available: Bool)
}
