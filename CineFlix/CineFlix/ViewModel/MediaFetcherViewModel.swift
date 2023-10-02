//
//  MediaFetcherViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation
import Locksmith

class MediaFetcherViewModel {
    
    // MARK: - Properties
    weak var delegate: UpdateView?
    
    public var trending = [Media]()
    public var upcoming = [Media]()
    public var topRated = [Media]()
    public var popular = [Media]()
    public var discover = [Media]()
    public var arrayOfMediaByGenre = [Media]()
    public var genres = [Genre]()
    
    // MARK: - Session Deletion
    public func delSession() {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        AuthAPI.shared.deleteSession(sessionId: dictionary["session"] as! String)
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "MyAccount")
            try Locksmith.deleteDataForUserAccount(userAccount: "Session")
        } catch {
            print(error)
        }
    }
    
    // MARK: - Data Fetching
    public func fetchGenres(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadGenresForMedia(type: type) { genres in
            self.genres = genres
            completion()
        }
    }
    public func fetchTrending(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadTrending(type: type) { media in
            self.trending = media
            completion()
        }
    }
    
    public func fetchUpcoming(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadUpcoming(type: type) { media in
            self.upcoming = media
            completion()
        }
    }
    
    public func fetchTopRated(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadTopRated(type: type) { media in
            self.topRated = media
            completion()
        }
    }
    
    public func fetchPopular(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadPopular(type: type) { media in
            self.popular = media
            completion()
        }
    }
    
    public func fetchDiscover(type: String, completion: @escaping () -> Void) {
        MediaAPI.shared.loadDiscover(type: type) { media in
            self.discover = media
            completion()
        }
    }
}
