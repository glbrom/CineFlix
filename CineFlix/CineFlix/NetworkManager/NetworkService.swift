//
//  NetworkService.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation
import Alamofire

// MARK: - API Configuration
enum APIConfig {
    static let apiKey = "ecb7633c4bad0d0b394a7598da19a63f"
    static let baseURL = "https://api.themoviedb.org"
}

// MARK: - URL Constants
enum URLConstants {
    static let registrationAccount = "https://www.themoviedb.org/signup"
    static let forgotPassword = "https://www.themoviedb.org/reset-password"
}

// MARK: - Social Media Links
enum SocialMediaLinks {
    static let linkedIn = "https://www.linkedin.com/in/glbrom/"
    static let gitHub = "https://github.com/glbrom"
}

// MARK: - Authentication API
class AuthAPI {
    static let shared = AuthAPI()
    
    private init() {}
    
    func createRequestToken(completion: @escaping (String) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/authentication/token/new?api_key=\(APIConfig.apiKey)", method: .get)
        genresRequest.responseDecodable(of: TokenResponce.self) { response in
            do {
                let data = try response.result.get().request_token
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func createSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping () -> Void){
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/authentication/token/validate_with_login?api_key=\(APIConfig.apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                _ = try response.result.get()
                completion()
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func createSession(requestToken: String, completion: @escaping (SessionResponce) -> Void) {
        let parameters: [String: Any] = [
            "request_token": requestToken
        ]
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/authentication/session/new?api_key=\(APIConfig.apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func createGuestSession(completion: @escaping (SessionResponce) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/authentication/guest_session/new?api_key=\(APIConfig.apiKey)", method: .get)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func deleteSession(sessionId: String) {
        let parameters: [String: Any] = [
            "session_id": sessionId
        ]
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/authentication/session?api_key=\(APIConfig.apiKey)", method: .delete, parameters: parameters, encoding: JSONEncoding.default)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                print(data.success)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
}

// MARK: - Account API
class AccountAPI {
    static let shared = AccountAPI()
    
    private init() {}
    
    func getAccountId(sessionId: String, completion: @escaping (AccountID) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account?api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .get)
        genresRequest.responseDecodable(of: AccountID.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func addToWatchlist(watchlist: Bool, accountID: Int, mediaType: String, mediaId: Int, sessionId: String, completion: @escaping (SessionResponce, String) -> Void) {
        let parameters: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaId,
            "watchlist": watchlist
        ]
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account/\(accountID)/watchlist?api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data, mediaType)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func getWatchlist(type: String, accountId: Int, sessionId: String, completion: @escaping([Media])-> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account/\(accountId)/watchlist/\(type)?language=en-US&sort_by=created_at.asc&page=1&api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func removeFromWatchlist(accountID: Int, mediaType: String, mediaId: Int, sessionId: String, completion: @escaping (SessionResponce, Int) -> Void) {
        let parameters: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaId,
            "watchlist": false
        ]
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account/\(accountID)/watchlist?api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data, mediaId)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func getMovieWatchlist(accountId: Int, sessionId: String, completion: @escaping([Media]) -> ()) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account/\(accountId)/watchlist/movies?language=en-US&sort_by=created_at.asc&page=1&api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                //                                self.arrayOfMoviesWatchlist = try response.result.get().results
                let data = try response.result.get().results
                //                self.arrayOfMoviesWatchlist = data.reversed()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func getTVShowsWatchlist(accountId: Int, sessionId: String, completion: @escaping(([Media])->())) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/account/\(accountId)/watchlist/tv?language=en-US&sort_by=created_at.asc&page=1&api_key=\(APIConfig.apiKey)&session_id=\(sessionId)", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
}

// MARK: - Media API
class MediaAPI {
    static let shared = MediaAPI()
    
    private init() {}
    
    func loadGenresForMedia(type: String, completion: @escaping ([Genre]) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/genre/\(type)/list?api_key=\(APIConfig.apiKey)&language=en-US", method: .get)
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
                let data = try response.result.get().genres
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadTrending(type: String, completion: @escaping([Media]) -> Void) {
        let movieRequest = AF.request("\(APIConfig.baseURL)/3/trending/\(type)/day?api_key=\(APIConfig.apiKey)", method: .get)
        movieRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadUpcoming(type: String, completion: @escaping([Media]) -> Void) {
        let movieRequest = AF.request("\(APIConfig.baseURL)/3/\(type)/upcoming?api_key=\(APIConfig.apiKey)&language=en-US&page=1", method: .get)
        movieRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadTopRated(type: String, completion: @escaping([Media]) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/\(type)/top_rated?api_key=\(APIConfig.apiKey)&language=en-US&page=1", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    func loadPopularMovies(completion: @escaping ([Media]) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/movie/popular?api_key=\(APIConfig.apiKey)&language=en-US&page=1", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadPopular(type: String, completion: @escaping ([Media]) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/\(type)/popular?api_key=\(APIConfig.apiKey)&language=en-US&page=1", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadDiscover(type: String, completion: @escaping ([Media]) -> Void) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/discover/\(type)?api_key=\(APIConfig.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate", method: .get)
        genresRequest.responseDecodable(of: MediaResponse.self) { response in
            do {
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadMediaByGenre(type: String, page: Int, genre: Int, completion: @escaping ([Media]) -> Void) {
        let movieRequest = AF.request("\(APIConfig.baseURL)/3/discover/\(type)?api_key=\(APIConfig.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&page=\(page)&include_video=false&with_genres=\(genre)&with_watch_monetization_types=flatrate", method: .get)
        movieRequest.responseDecodable(of: MediaResponse.self) { responce in
            do {
                let data = try responce.result.get().results
                completion(data)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    func loadTrailer(mediaType: String, movieId: Int, completion: @escaping ([Video]) -> ()) {
        let genresRequest = AF.request("\(APIConfig.baseURL)/3/\(mediaType)/\(movieId)/videos?api_key=\(APIConfig.apiKey)", method: .get)
        genresRequest.responseDecodable(of: VideoResponse.self) { response in
            do {
                let data = try response.result.get().results
                let filtered = data.filter { video in
                    return video.type.rawValue == "Trailer"
                }
                completion(filtered)
            }
            catch {
                print("error: \(error)")
            }
        }
    }
    
    func search(page: Int, query: String, completion: @escaping([Media]) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let movieRequest = AF.request("\(APIConfig.baseURL)/3/search/movie?api_key=\(APIConfig.apiKey)&page=\(page)&query=\(query)", method: .get)
        movieRequest.responseDecodable(of: MediaResponse.self) { responce in
            do {
                let data = try responce.result.get().results
                completion(data)
            } catch {
                print("error: \(error)")
            }
        }
    }
}
