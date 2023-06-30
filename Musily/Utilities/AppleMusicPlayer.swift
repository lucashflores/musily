//
//  MusicPlayer.swift
//  Musily
//
//  Created by Lucas Flores on 30/06/23.
//

import Foundation
import MusicKit

class AppleMusicPlayer {
    private var player: ApplicationMusicPlayer = ApplicationMusicPlayer.shared
    
    func getPlaybackStatus() -> MusicPlayer.PlaybackStatus {
        return player.state.playbackStatus
    }
    
    func isPlayerQueueEmpty() -> Bool {
        return player.queue.entries.isEmpty
    }
    
    func playsMusic(musica: Song) async {
        do{
            player.queue = [musica]
            try await player.prepareToPlay()
            try await player.play()
        } catch {
            print(error)
        }
    }

    func resumeSong() {
        Task {
            do {
                try await player.play()
            }
           catch {

            }
        }
    }

    func playsSong (musica : Song) {
        Task {
            await playsMusic(musica: musica)
        }
    }
    
    func pause() {
        player.pause()
    }
}
