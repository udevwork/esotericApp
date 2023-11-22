//
//  TarotModels.swift
//  Esoteric
//
//  Created by Alex on 21.11.2023.
//

import Foundation

struct TarotModel: Codable {
    let userQuestion: String
    let answer: String
    let time: TimeInterval
}
