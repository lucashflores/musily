import Foundation

enum NetworkError: Error {
    case invalidData
    case invalidStatusCode
    case badServerResponse
}
