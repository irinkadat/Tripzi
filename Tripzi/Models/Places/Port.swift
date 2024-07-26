//
//  Port.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PortResponse: Decodable {
    let data: Locations
}

struct SuggestedPortResponse: Hashable, Decodable {
    let data: [Port]
}

struct Locations: Decodable {
    let locations: PortData
}

struct PortData: Hashable, Decodable {
    let ports: [Port]
}

struct Port: Decodable, Hashable {
    let code: String
    let name: String
    let city: City
    let country: Country
    let port: PortDetail?
    let region: Region?
    let domestic: Bool
    let ports: [String]
    let type: String
}

struct PortDetail: Decodable, Hashable {
    let code: String?
    let name: String?
}

struct Region: Decodable, Hashable {
    let code: String?
    let name: String?
}


