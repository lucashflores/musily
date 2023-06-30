//
//  ChatGPTAnswer.swift
//  Musily
//
//  Created by Lucas Flores on 29/06/23.
//

import Foundation

struct Message: Codable {
    var content: String
}

struct Choice: Codable {
    var message: Message
}

struct ChatGPTAnswer: Codable {
    var id: String
    var created: Int
    var choices: [Choice]
}
