//
//  User.swift
//  BeRealClone
//
// Created by Leonardo Villalobos on 3/6/23.
//

import Foundation
import ParseSwift

/*
    - TODO -
    Fetch the 10 most recent photos within the last 24 hours from the server. - Of those returned in the response,
    only show the post if the createdAt property is within 24 hours of the logged in user’s last post. - You can
    either obstruct the photo (see blurred photo in stretch goals) or just not show it to the user.
 */

struct User: ParseUser {
    var lastPostedDate: Date?
    
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
}

// MARK: Implement User
extension User {
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}

// MARK: Conform User to CustomStringConvertible
extension User: CustomStringConvertible {
    var description: String {
        return "User{username=\(username ?? "")," + "email=\(email ?? "")}"
    }
}
