import Foundation

class NetworkManager {
    public static let shared = NetworkManager()
    private var apiKey = "1022157a16dd78bde564ece99bed68b2"
    
    func getArtistInfo(artistName: String, completed: @escaping (Result<LastFMArtistResponse, NetworkError>) -> Void) {
        let requestURL = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=\(artistName)&api_key=\(apiKey)&format=json"
        makeLastFMRequest(requestURL: requestURL, responseType: LastFMArtistResponse.self, completed: completed)
    }
    
    func getAlbumInfo(artistName: String, albumTitle: String, completed: @escaping (Result<LastFMAlbumResponse, NetworkError>) -> Void) {
        let requestURL = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(apiKey)&artist=\(artistName)&album=\(albumTitle)&format=json"
        makeLastFMRequest(requestURL: requestURL, responseType: LastFMAlbumResponse.self, completed: completed)
    }
    
    func getTrackInfo(artistName: String, trackTitle: String, completed: @escaping (Result<LastFMTrackResponse, NetworkError>) -> Void) {
        let requestURL = "https://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=\(apiKey)&artist=\(artistName)&track=\(trackTitle)&format=json"
        makeLastFMRequest(requestURL: requestURL, responseType: LastFMTrackResponse.self, completed: completed)
    }
    
    func getGenreInfo(genre: String, completed: @escaping (Result<LastFMTagResponse, NetworkError>) -> Void) {
        let requestURL = "https://ws.audioscrobbler.com/2.0/?method=tag.getinfo&api_key=\(apiKey)&tag=\(genre)&format=json"
        makeLastFMRequest(requestURL: requestURL, responseType: LastFMTagResponse.self, completed: completed)
    }
    
    func makeLastFMRequest<T: Codable>(requestURL: String, responseType: T.Type, completed: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: URL(string: requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = NetworkSession()
        session.execute(responseType: responseType, request: request, completed: completed)
    }
}
