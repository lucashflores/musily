//
//  AppleMusicAlbum.swift
//  Musily
//
//  Created by Lucas Flores on 01/07/23.
//

import Foundation

public struct AppleMusicAlbum: Identifiable, Hashable {
    public var id = UUID()
    public var title: String?
    public var artworkURL: URL?
    
    public static func getDefault() -> AppleMusicAlbum {
        return AppleMusicAlbum(title: "Shirt - Single", artworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/83/86/b4/8386b45a-4c4d-4fe7-90cc-d006df085de4/196589552242.jpg/300x300bb.jpg")!)
    }
}
