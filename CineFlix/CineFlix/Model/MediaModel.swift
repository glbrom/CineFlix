//
//  Media.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation

// MARK: - Media Response
struct MediaResponse: Codable {
    let page: Int
    let results: [Media]
    let total_pages: Int
    let total_results: Int
}

// MARK: - Media
struct Media: Codable {
    let backdrop_path: String?
    let id: Int
    let name: String?
    let title: String?
    let original_name: String?
    let original_language: String
    let original_title: String?
    let overview: String
    let poster_path: String?
    let genre_ids: [Int]
    let popularity: Double
    let first_air_date: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
}

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}
