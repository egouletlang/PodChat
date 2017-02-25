//
//  BaseSpeechRecognitionHelper.swift
//  PodSpeech
//
//  Created by Etienne Goulet-Lang on 2/25/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import Speech
import AVFoundation
import BaseUtils

open class BaseSpeechRecognitionHelper: NSObject, SFSpeechRecognizerDelegate {
    
    // MARK: - Constructor & Instance Pattern -
    public override init() {
        super.init()
        config()
        reset()
    }
    
    // MARK: - Private Variables -
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - contextualStrings helps the speech recognition favor certain words -
    open var contextualStrings: [String] = []
    
    // MARK: - Report Partial Recognition Results -
    open var shouldReportPartialResults = false
    
    // MARK: - locale that should be used to do the speech recognition -
    open var locale = "en-US" {
        didSet {
            self.reset()
        }
    }
    
    // MARK: - Delegate -
    weak open var speechRecognitionHelperDelegate: SpeechRecognitionHelperDelegate?
    
    
    //MARK: - Status -
    open func isAvailable() -> Bool {
        return self.speechRecognizer?.isAvailable ?? false
    }
    
    open func authorize(callback: @escaping (UIViewController?) -> Void) {
        switch (SFSpeechRecognizer.authorizationStatus()) {
        case .authorized:
            callback(nil)
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { (status) in
                switch (status) {
                case .authorized:
                    callback(nil)
                case.restricted, .denied:
                    callback(self.buildIOSSettingsAlert())
                case .notDetermined:
                    break
                }
                
            }
        case.restricted, .denied:
            callback(self.buildIOSSettingsAlert())
        }
    }
    
    private func buildIOSSettingsAlert() -> UIViewController {
        let alert = UIAlertController(title: "Speech & Microphone Permissions are Required",
                                      message: "Tap here to go to the iOS Settings Menu",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            ThreadHelper.executeOnMainThread {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil)
            }
        })
        return alert
    }
    
    open func config() {}
    
    // MARK: - Reinitialize the speech recognition component -
    open func reset() {
        stop()
        
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: locale))
        self.speechRecognizer?.delegate = self
        
        if (SFSpeechRecognizer.authorizationStatus() == .authorized) {
            SFSpeechRecognizer.requestAuthorization { (authStatus) in }
        }
    }
    
    // MARK: - Start recognizing -
    open func start() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = shouldReportPartialResults  //6
        recognitionRequest.contextualStrings = self.contextualStrings
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                self.newText(text: result?.bestTranscription.formattedString)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    // MARK: - Stop recognizing -
    open func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
    }
    
    
    open func newText(text: String?) {
        self.speechRecognitionHelperDelegate?.SRH_newText?(text: text, final: true)
    }
    
    // MARK: - SFSpeechRecognizerDelegate Implementation -
    // MARK: Whenever the SpeechKit availability changes, the SpeechRecognitionHelperDelegate is notified
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        self.speechRecognitionHelperDelegate?.SRH_newStatus?(available: available)
    }
    
}
