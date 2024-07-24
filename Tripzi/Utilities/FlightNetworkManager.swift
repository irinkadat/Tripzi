//
//  NetworkManager.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation
import NetService

class FlightNetworkManager {
    private let url = "https://www.turkishairlines.com/api/v1/availability"
    private let headers = [
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/json",
        "X-Bfp": "eefd623666b7d32de067e67c19cdbcbe",
        "X-Clientid": "fdc44a1f-aaee-46bd-aaa3-3f8539ee3bc8",
        "X-Conversationid": "68006240-6101-4a7e-9dc2-c384d695ca9c",
        "X-Country": "int",
        "X-Requestid": "b604f200-7ba5-45b7-a80d-e769f76e16af"
    ]
    
    private let networkService = NetworkService()
    
    func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightOption], Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(payload)
            let body = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] ?? [:]
            
            networkService.postData(urlString: url, body: body, headers: headers) { (result: Result<FlightResponse, Error>) in
                switch result {
                case .success(let flightResponse):
                    if flightResponse.success, let responseData = flightResponse.data {
                        let options = responseData.originDestinationInformationList.flatMap { $0.originDestinationOptionList }
                        completion(.success(options))
                    } else {
                        let errorDetail = flightResponse.message?.detail.first?.code ?? "Unknown error"
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDetail])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
