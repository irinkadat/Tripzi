//
//  NetworkManager.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

//import Foundation
//
//struct FlightSearchPayload: Codable {
//    let moduleType: String
//    let originDestinationInformationList: [OriginDestinationInformation]
//    let passengerTypeList: [PassengerType]
//    let selectedBookerSearch: String
//    let selectedCabinClass: String
//}
//
//struct OriginDestinationInformation: Codable {
//    let destinationAirportCode: String
//    let destinationMultiPort: Bool
//    let originAirportCode: String
//    let departureDate: String
//}
//
//struct PassengerType: Codable {
//    let quantity: Int
//    let code: String
//}
//
//struct FlightCode: Codable {
//    let airlineCode: String
//    let flightNumber: String
//    let leaseCode: String?
//}
//
//struct CarrierAirline: Codable {
//    let airlineName: String?
//    let airlineCode: String
//}
//
//struct FlightSegment: Codable {
//    let departureAirportCode: String
//    let arrivalAirportCode: String
//    let departureDateTime: String
//    let arrivalDateTime: String
//    let flightCode: FlightCode
//    let connected: Bool
//    let rph: String?
//    let codeShareInd: String?
//    let journeyDurationInMillis: Int
//    let groundDuration: Int
//    let codeSharingAirline: String?
//    let carrierAirline: CarrierAirline
//    let spaFlight: Bool
//    let equipmentCode: String
//    let stopCount: Int
//    let containsTransitVisaRequiredPort: Bool
//    let tourIstanbul: Bool
//    let stopoverHotel: Bool
//    let technicalStops: [String]
//}
//
//struct FlightOption: Codable {
//    let optionId: Int
//    let segmentList: [FlightSegment]
//}
//
//struct OriginDestinationOption: Codable {
//    let outboundFlightId: String?
//    let departureDate: String
//    let arrivalDate: String?
//    let originLocation: String
//    let destinationLocation: String
//    let soldOutAllFlights: Bool
//    let originDestinationOptionList: [FlightOption]
//}
//
//struct CurrencyAmount: Codable {
//    let currencyCode: String
//    let amount: Double
//    let currencySign: String
//    let decimalPlaces: Int
//}
//
//struct StartingPrice: Codable {
//    let brandCode: String
//    let startingPrice: CurrencyAmount?
//}
//
//struct FlightResponseData: Codable {
//    let originDestinationInformationList: [OriginDestinationOption]
//    let economyStartingPrice: StartingPrice?
//    let businessStartingPrice: StartingPrice?
//}
//
//struct FlightResponse: Codable {
//    let data: FlightResponseData?
//    let success: Bool
//    let message: ResponseMessage?
//}
//
//struct ResponseMessage: Codable {
//    let detail: [ResponseDetail]
//}
//
//struct ResponseDetail: Codable {
//    let code: String
//    let args: [String]?
//}
//
//class NetworkManager {
//    private let url = URL(string: "https://www.turkishairlines.com/api/v1/availability")!
//    private let headers = [
//        "Accept": "application/json, text/plain, */*",
//        "Content-Type": "application/json",
//        "X-Bfp": "eefd623666b7d32de067e67c19cdbcbe",
//        "X-Clientid": "fdc44a1f-aaee-46bd-aaa3-3f8539ee3bc8",
//        "X-Conversationid": "68006240-6101-4a7e-9dc2-c384d695ca9c",
//        "X-Country": "int",
//        "X-Requestid": "b604f200-7ba5-45b7-a80d-e769f76e16af"
//    ]
//    
//    func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightSegment], Error>) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        
//        do {
//            let jsonData = try JSONEncoder().encode(payload)
//            request.httpBody = jsonData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
////            if response is HTTPURLResponse {
////
////            }
//            
//            do {
//                let flightResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
//                
//                if flightResponse.success, let responseData = flightResponse.data {
//                    let segments = responseData.originDestinationInformationList.flatMap { $0.originDestinationOptionList.flatMap { $0.segmentList } }
//                    completion(.success(segments))
//                } else if let message = flightResponse.message {
//                    let errorDetail = message.detail.first?.code ?? "Unknown error"
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDetail])))
//                } else {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
//                }
//            } catch {
//                print("Decoding error: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}


import Foundation

// Define the top-level response struct
struct FlightResponse: Codable {
    let data: FlightResponseData?
    let success: Bool
    let message: ResponseMessage?
}

struct FlightResponseData: Codable {
    let originDestinationInformationList: [OriginDestinationOption]
    let economyStartingPrice: StartingPrice?
    let businessStartingPrice: StartingPrice?
}

struct OriginDestinationOption: Codable {
    let outboundFlightId: String?
    let departureDate: String
    let arrivalDate: String?
    let originLocation: String
    let destinationLocation: String
    let filterAndSortParameters: FilterAndSortParameters?
    let soldOutAllFlights: Bool
    let originDestinationOptionList: [FlightOption]
}

struct FilterAndSortParameters: Codable {
    let minFlightCountForSorting: Int
    let minFlightCountForTimeRangeFiltering: Int
    let minFlightCountForOptionsFiltering: Int
    let defaultFlightSortingParameter: String
    let maximumDaysForAvailability: Int
}

struct FlightOption: Codable {
    let optionId: Int
    let segmentList: [FlightSegment]
}

struct FlightSegment: Codable {
    let departureAirportCode: String
    let arrivalAirportCode: String
    let departureDateTime: String
    let arrivalDateTime: String
    let flightCode: FlightCode
    let connected: Bool
    let rph: String?
    let codeShareInd: String?
    let journeyDurationInMillis: Int
    let groundDuration: Int
    let codeSharingAirline: String?
    let carrierAirline: CarrierAirline
    let spaFlight: Bool
    let equipmentCode: String
    let stopCount: Int
    let containsTransitVisaRequiredPort: Bool
    let tourIstanbul: Bool
    let stopoverHotel: Bool
    let technicalStops: [String]
}

struct FlightCode: Codable {
    let airlineCode: String
    let flightNumber: String
    let leaseCode: String?
}

struct CarrierAirline: Codable {
    let airlineName: String?
    let airlineCode: String
}

struct StartingPrice: Codable {
    let brandCode: String
    let startingPrice: CurrencyAmount?
}

struct CurrencyAmount: Codable {
    let currencyCode: String
    let amount: Double
    let currencySign: String
    let decimalPlaces: Int
}

struct ResponseMessage: Codable {
    let detail: [ResponseDetail]
}

struct ResponseDetail: Codable {
    let code: String
    let args: [String]?
}

// Define the payload struct
struct FlightSearchPayload: Codable {
    let moduleType: String
    let originDestinationInformationList: [OriginDestinationInformation]
    let passengerTypeList: [PassengerType]
    let selectedBookerSearch: String
    let selectedCabinClass: String
}

struct OriginDestinationInformation: Codable {
    let destinationAirportCode: String
    let destinationMultiPort: Bool
    let originAirportCode: String
    let departureDate: String
}

struct PassengerType: Codable {
    let quantity: Int
    let code: String
}

class NetworkManager {
    private let url = URL(string: "https://www.turkishairlines.com/api/v1/availability")!
    private let headers = [
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/json",
        "X-Bfp": "eefd623666b7d32de067e67c19cdbcbe",
        "X-Clientid": "fdc44a1f-aaee-46bd-aaa3-3f8539ee3bc8",
        "X-Conversationid": "68006240-6101-4a7e-9dc2-c384d695ca9c",
        "X-Country": "int",
        "X-Requestid": "b604f200-7ba5-45b7-a80d-e769f76e16af"
    ]
    
    func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightSegment], Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let flightResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
                
                if flightResponse.success, let responseData = flightResponse.data {
                    let segments = responseData.originDestinationInformationList.flatMap { $0.originDestinationOptionList.flatMap { $0.segmentList } }
                    completion(.success(segments))
                } else if let message = flightResponse.message {
                    let errorDetail = message.detail.first?.code ?? "Unknown error"
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDetail])))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
