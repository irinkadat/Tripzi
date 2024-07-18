//
//  Port.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

struct PortResponse: Hashable, Codable {
    let data: [Port]
}

struct Port: Hashable, Codable {
    let code: String
    let name: String
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}

struct City: Hashable, Codable {
    let code: String
    let name: String
}

struct PortDetail: Hashable, Codable {
    let code: String
    let name: String
}

struct Region: Hashable, Codable {
    let code: String
    let name: String
}
