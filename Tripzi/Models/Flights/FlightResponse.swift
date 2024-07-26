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

struct FlightOption: Decodable {
    let optionId: Int
    let segmentList: [FlightSegment]
    let startingPrice: FlightPrice?
}

struct FlightPrice: Decodable {
    let currencyCode: String
    let amount: Double
    let currencySign: String?
    let decimalPlaces: Int?
}

struct FlightSegment: Decodable {
    let departureAirportCode: String
    let arrivalAirportCode: String
    let departureDateTime: String
    let arrivalDateTime: String
    let flightCode: FlightCode
    let connected: Bool
    let rph: String?
    let codeShareInd: String?
    let journeyDurationInMillis: Int
    let carrierAirline: CarrierAirline
    let containsTransitVisaRequiredPort: Bool
}

struct FlightCode: Decodable {
    let airlineCode: String
    let flightNumber: String
    let leaseCode: String?
}

struct CarrierAirline: Decodable {
    let airlineName: String?
    let airlineCode: String
}

struct ResponseMessage: Decodable {
    let detail: [ResponseDetail]
}

struct ResponseDetail: Decodable {
    let code: String
    let args: [String]?
}

struct FlightSearchPayload: Decodable {
    let moduleType: String
    let originDestinationInformationList: [OriginDestinationInformation]
    let passengerTypeList: [PassengerType]
    let selectedBookerSearch: String
    let selectedCabinClass: String
}

struct OriginDestinationInformation: Decodable {
    let destinationAirportCode: String
    let destinationMultiPort: Bool
    let originAirportCode: String
    let departureDate: String
}

struct PassengerType: Decodable {
    let quantity: Int
    let code: String
}
