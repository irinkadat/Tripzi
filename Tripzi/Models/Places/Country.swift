//
//  Country.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct CountryResponse: Hashable, Decodable {
    let data: CountryData
}

struct CountryData: Hashable, Decodable {
    let countries: [[Country]]
}

struct City: Decodable, Hashable {
    let code: String
    let name: String
}

struct Country: Decodable, Hashable {
    let code: String
    let name: String
}
