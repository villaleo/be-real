//
//  Post.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/29/22.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
}

// impl Post
extension Post {
    init(caption: String, user: User, imageFile: ParseFile) {
        self.caption = caption
        self.user = user
        self.imageFile = imageFile
    }
}

// MARK: Confirm Post to CustomStringConvertible
extension Post: CustomStringConvertible {
    var description: String {
        guard let user = user else {
            return "Post{caption=\(caption ?? ""),user=<nil>"
        }
        return "Post{caption=\(caption ?? ""),user=\(user)"
    }
}
