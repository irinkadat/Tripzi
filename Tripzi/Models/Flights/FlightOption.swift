//
//  FlightOption.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation

struct FlightOption: Decodable {
    let optionId: Int
    let segmentList: [FlightSegment]
    let startingPrice: FlightPrice?
}

struct FlightSegment: Decodable {
    let departureAirportCode: String
    let arrivalAirportCode: String
    let departureDateTime: String
    let arrivalDateTime: String
    let connected: Bool
    let rph: String?
    let codeShareInd: String?
    let journeyDurationInMillis: Int
    let containsTransitVisaRequiredPort: Bool
}

struct FlightPrice: Decodable {
    let currencyCode: String
    let amount: Double
    let currencySign: String?
    let decimalPlaces: Int?
}
