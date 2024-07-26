//
//  Port.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PortResponse: Codable {
    let data: Locations
}

struct SuggestedPortResponse: Hashable, Codable {
    let data: [Port]
}

struct Locations: Codable {
    let locations: PortData
}

struct PortData: Hashable, Codable {
    let ports: [Port]
}

struct Port: Codable, Hashable {
    let code: String
    let name: String
    let city: City?
    let country: Country?
    let port: PortDetail?
    let region: Region?
    let domestic: Bool?
    let ports: [String]
    let type: String?
}

struct PortDetail: Codable, Hashable {
    let code: String?
    let name: String?
}

struct Region: Codable, Hashable {
    let code: String?
    let name: String?
}


