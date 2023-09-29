//
//  MediaSearchViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation

class MediaSearchViewModel {
    
    // MARK: - Properties
    public var currentPage = 0
    public let totalPages = 5
    public var searched = [Media]()
    public var genres = [Genre]()
    public var popular  = [Media]()
    
    // MARK: - Movie Search
    public func searchMovie(query: String, completion: @escaping()->Void) {
        currentPage += 1
        MediaAPI.shared.search(page: currentPage, query: query) { media in
            if self.currentPage == 1 {
                self.searched = media
            } else {
                self.searched += media
            }
            completion()
        }
    }
    
    // MARK: - Popular Movies Fetching
    public func fetchPopularMovies(completion: @escaping()->Void) {
        MediaAPI.shared.loadUpcoming(type: "movie", completion: { media in
            self.popular = media
            completion()
        })
    }
}
