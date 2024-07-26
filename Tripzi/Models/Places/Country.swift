//
//  Country.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct CountryResponse: Hashable, Codable {
    let data: CountryData
}

struct CountryData: Hashable, Codable {
    let countries: [[Country]]
}

struct City: Codable, Hashable {
    let code: String
    let name: String
}

struct Country: Codable, Hashable {
    let code: String?
    let name: String?
}
