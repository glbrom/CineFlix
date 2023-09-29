//
//  AuthenticationViewModel.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import Foundation
import Locksmith

class AuthenticationViewModel {
    
    // MARK: - Session Creation
    public func createSession(username: String, password: String, completion: @escaping (Bool) -> Void) {
        AuthAPI.shared.createRequestToken { token in
            do {
                try Locksmith.updateData(data: ["username": username, "password": password], forUserAccount: "MyAccount")
            } catch {
                print(error)
            }
            guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { return }
            AuthAPI.shared.createSessionWithLogin(username: dictionary["username"] as! String, password: dictionary["password"] as! String, requestToken: token) {
                AuthAPI.shared.createSession(requestToken: token) {
                    session in
                    AccountAPI.shared.getAccountId(sessionId: session.session_id ?? "") { account in
                        do {
                            try Locksmith.updateData(data: ["session" : session.session_id ?? "", "account": account.id ?? 0], forUserAccount: "Session")
                        } catch {
                            print(error)
                        }
                    }
                    completion(session.success)
                }
            }
        }
    }
    
    // MARK: - Guest Session Creation
    public func createGuestSession(completion: @escaping (SessionResponce) -> Void) {
        AuthAPI.shared.createGuestSession { responce in
            do {
                try Locksmith.updateData(data: ["session" : responce.guest_session_id ?? "", "account": 0], forUserAccount: "Session")
            } catch {
                print(error)
            }
            print(responce.guest_session_id ?? "")
            completion(responce)
        }
    }
    
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
}
