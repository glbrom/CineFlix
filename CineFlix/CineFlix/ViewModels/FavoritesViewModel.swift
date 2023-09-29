//
//  FavoritesViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation
import Locksmith

class FavoritesViewModel {
    
    // MARK: - Properties
    public var arrayOfMoviesWatchlist = [Media]()
    public var arrayOfTVShowsWatchlist = [Media]()
    public var movieGenres = [Genre]()
    public var tvGenres = [Genre]()
    
    // MARK: - Movie Watchlist Fetching
    public func fetchMovieWatchlist(completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.getMovieWatchlist(accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.arrayOfMoviesWatchlist = media.reversed()
            completion()
        }
    }
    
    // MARK: - TV Shows Watchlist Fetching
    public func fetchTVShowsWatchlist(completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.getTVShowsWatchlist(accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.arrayOfTVShowsWatchlist = media.reversed()
            completion()
        }
    }
    
    // MARK: - Removal from Watchlist
    public func remove(mediaType: String, mediaId: Int, completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.removeFromWatchlist(accountID: dictionary["account"] as! Int, mediaType: mediaType, mediaId: mediaId, sessionId: dictionary["session"] as! String) { session, mediaId in
            print(session, mediaId)
            completion()
        }
    }
    
    // MARK: - Genre Fetching
    public func fetchMovieGenres() {
        MediaAPI.shared.loadGenresForMedia(type: "movie") { genres in
            self.movieGenres = genres
        }
    }
    
    public func fetchTVGenres() {
        MediaAPI.shared.loadGenresForMedia(type: "tv") { genres in
            self.tvGenres = genres
        }
    }
}
