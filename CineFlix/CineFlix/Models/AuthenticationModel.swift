//
//  Authentication.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation

// MARK: - Token Response
struct TokenResponce: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
}

// MARK: - Session Response
struct SessionResponce: Codable {
    let success: Bool
    let failure: Bool?
    let status_code: Int?
    let status_message: String?
    let session_id: String?
    let guest_session_id: String?
}

// MARK: - Account ID
struct AccountID: Codable {
    let id: Int?
    let iso639_1: String?
    let so3166_1: String?
    let name: String?
    let include_adult: Bool?
    let username: String?
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
}
