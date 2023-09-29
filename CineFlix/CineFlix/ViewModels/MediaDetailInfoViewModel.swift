//
//  MediaDetailInfoViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation
import Locksmith

class MediaDetailInfoViewModel {
    
    // MARK: - Properties
    public var arrayOfViedos = [Video]()
    
    public var movieGenres = [Genre]()
    public var tvGenres = [Genre]()
    
    public var watchlist = [Media]()
    public var movieWatchlist = [Media]()
    public var tvWatchlist = [Media]()
    
    // MARK: - Genre Fetching
    public func fetchMovieGenres(completion: @escaping ([Genre]) -> Void) {
        MediaAPI.shared.loadGenresForMedia(type: "movie") { genres in
            self.movieGenres = genres
            print("MOVIE: \(genres)")
            completion(genres)
        }
    }
    public func fetchTVGenres(completion: @escaping ([Genre]) -> Void) {
        MediaAPI.shared.loadGenresForMedia(type: "tv") { genres in
            self.tvGenres = genres
            print("TV: \(genres)")
            completion(genres)
        }
    }
    
    // MARK: - Trailer Loading
    public func loadTrailers(mediaType: String, movieId: Int, completion: @escaping () -> Void) {
        MediaAPI.shared.loadTrailer(mediaType: mediaType, movieId: movieId) { videos in
            self.arrayOfViedos = videos
            completion()
        }
    }
    
    // MARK: - Watchlist Handling
    public func addToWatchlist(watchlist: Bool, mediaType: String, mediaId: Int, completion: @escaping () -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.addToWatchlist(watchlist: watchlist, accountID: dictionary["account"] as! Int, mediaType: mediaType, mediaId: mediaId, sessionId: dictionary["session"] as! String) { data, mediaType in
            print(data, mediaType)
            completion()
        }
    }
    public func getWatchlist(type: String, completion: @escaping () -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.getWatchlist(type: type, accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.watchlist = media
            completion()
        }
    }
    
    public func getMovieWatchlist(completion: @escaping ([Media]) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.getWatchlist(type: "movies", accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.movieWatchlist = media
            completion(media)
        }
    }
    
    public func getTVWatchlist(completion: @escaping ([Media]) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AccountAPI.shared.getWatchlist(type: "tv", accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.tvWatchlist = media
            completion(media)
        }
    }
}
