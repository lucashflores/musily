import Foundation
import SwiftUI
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

    func playsSong (musica : Song, isPresented : Binding<Bool>) {
        Task {
            await playsMusic(musica: musica)
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func addsToPlaylist (musica: Song) {
        Task{
            let library = MusicLibrary.shared
            let playlist = try await library.createPlaylist(name: "Recommendations")
            try await library.add(musica, to: playlist)
        }
    }
}
