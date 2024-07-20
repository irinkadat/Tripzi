//
//  Port.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PortResponse: Codable {
    let data: PortData
}

struct PportResponse: Hashable, Codable {
    let data: [Port]
}

struct PortData: Hashable, Codable {
    let ports: [Port]
}

struct Port: Codable, Hashable {
    let code: String
    let name: String
    let city: City
    let country: Country
    let multi: Bool
    let port: PortDetail
    let region: Region
    let domestic: Bool
    let hideInBooker: Bool
    let starAwardTicket: Bool
    let ports: [String]
    let type: String
}

struct City: Codable, Hashable {
    let code: String
    let name: String
}

struct Country: Codable, Hashable {
    let code: String
    let name: String
}

struct PortDetail: Codable, Hashable {
    let code: String
    let name: String
}

struct Region: Codable, Hashable {
    let code: String
    let name: String
}

struct CountryResponse: Hashable, Codable {
    let data: CountryData
}

struct CountryData: Hashable, Codable {
    let countries: [[Country]]
}
