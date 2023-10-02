//
//  MediaGenresViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation

class MediaGenresViewModel {
    
    // MARK: - Properties
    public var currentPage = 0
    public let totalPages = 3
    public var genres = [Genre]()
    public var arrayOfMediaByGenre = [Media]()
    
    // MARK: - Media Fetching
    public func fetchMedia(type: String, genre: Int, completion: @escaping () -> Void) {
        currentPage += 1
        MediaAPI.shared.loadMediaByGenre(type: type, page: currentPage, genre: genre) { media in
            self.arrayOfMediaByGenre += media
            completion()
        }
    }
}
