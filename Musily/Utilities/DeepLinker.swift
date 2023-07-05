//
//  DeepLin k.swift
//  Musily
//
//  Created by Lucas Flores on 03/07/23.
//

import Foundation
import UIKit

class DeepLinker {
    func redirect(url: URL) {
        Task {
            await UIApplication.shared.open(url)
        }
    }
}
