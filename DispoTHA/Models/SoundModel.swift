//
//  SoundModel.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import AVKit

class SoundModel {
    
    // MARK:- variables
    static var shared = SoundModel()
    
    var audioPlayer: AVAudioPlayer! = nil

    // MARK:- functions
    func playRefresh() {
        let path = Bundle.main.path(forResource: "refresh", ofType: "wav")
        let url = URL(fileURLWithPath: path!)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
}
