//
//  SpeechSynthesisHelperDelegate.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation


@objc
public protocol SpeechSynthesisHelperDelegate: NSObjectProtocol {
    @objc optional func SSH_speechStatus(on: Bool)
}
