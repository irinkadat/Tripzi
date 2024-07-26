//
//  FlightResponse.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import Foundation

struct FlightResponse: Decodable {
    let data: FlightResponseData?
    let success: Bool
    let message: ResponseMessage?
}

struct FlightResponseData: Decodable {
    let originDestinationInformationList: [OriginDestinationOption]
}

struct OriginDestinationOption: Decodable {
    let outboundFlightId: String?
    let departureDate: String
    let arrivalDate: String?
    let originLocation: String
    let destinationLocation: String
    let filterAndSortParameters: FilterAndSortParameters?
    let soldOutAllFlights: Bool
    let originDestinationOptionList: [FlightOption]
}

struct FilterAndSortParameters: Decodable {
    let minFlightCountForSorting: Int
    let minFlightCountForTimeRangeFiltering: Int
    let minFlightCountForOptionsFiltering: Int
    let defaultFlightSortingParameter: String
    let maximumDaysForAvailability: Int
}

struct ResponseMessage: Decodable {
    let detail: [ResponseDetail]
}

struct ResponseDetail: Decodable {
    let code: String
    let args: [String]?
}

struct FlightSearchPayload: Encodable {
    let moduleType: String
    let originDestinationInformationList: [OriginDestinationInformation]
    let passengerTypeList: [PassengerType]
    let selectedBookerSearch: String
    let selectedCabinClass: String
}

struct OriginDestinationInformation: Encodable {
    let destinationAirportCode: String
    let destinationMultiPort: Bool
    let originAirportCode: String
    let departureDate: String
}

struct PassengerType: Encodable {
    let quantity: Int
    let code: String
}
