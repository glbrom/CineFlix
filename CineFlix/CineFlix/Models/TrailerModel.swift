//
//  Trailer.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation

// MARK: - Video Response
struct VideoResponse: Codable {
    let id: Int
    let results: [Video]
}

// MARK: - Video
struct Video: Codable {
    let key: String
    let type: TypeEnum
}

// MARK: - Type Enum
enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case bloopers = "Bloopers"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}
