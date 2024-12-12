//
//  FeedbackService.swift
//  TripJournal
//
//  Created by Hung Truong on 12/11/24.
//

import AVFoundation
import SwiftUI

enum FeedbackType {
    case success
    case error
    
    var soundFileName: String {
        switch self {
        case .success:
            return "success"
        case .error:
            return "error"
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        }
    }
}

class FeedbackService {
    static let shared = FeedbackService()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func provideFeedback(_ type: FeedbackType) {
        playSound(named: type.soundFileName)
    }
    
    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            
            // Check if device is in silent mode
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.outputVolume > 0 {
                audioPlayer?.play()
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
