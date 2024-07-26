//
//  TipItem.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct TipGroup: Decodable {
    let count: Int
    let items: [TipItem]?
}

struct Tips: Decodable {
    let count: Int?
    let groups: [TipGroup]?
}

struct TipItem: Decodable {
    let id: String
    let createdAt: Int
    let text: String
    let agreeCount: Int
    let disagreeCount: Int
    let user: TipUser?
}

struct TipUser: Decodable {
    let id: String
    let firstName: String
    let lastName: String?
    let photo: UserPhoto?
}

struct UserPhoto: Decodable {
    let prefix: String
    let suffix: String
}
