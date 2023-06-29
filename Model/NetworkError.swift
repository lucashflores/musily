//
//  NetworkErrors.swift
//  Musily
//
//  Created by Lucas Flores on 29/06/23.
//

import Foundation

enum NetworkError: Error {
    case invalidData
    case invalidStatusCode
    case badServerResponse
}
