//
//  TipItem.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct TipGroup: Codable {
    let count: Int
    let items: [TipItem]?
}

struct Tips: Codable {
    let count: Int?
    let groups: [TipGroup]?
}

struct TipItem: Codable {
    let id: String
    let createdAt: Int
    let text: String
    let agreeCount: Int
    let disagreeCount: Int
    let user: TipUser?
}

struct TipUser: Codable {
    let id: String
    let firstName: String
    let lastName: String?
    let photo: UserPhoto?
}

struct UserPhoto: Codable {
    let prefix: String
    let suffix: String
}
