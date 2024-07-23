//
//  NetworkManager.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

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
    
    func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightOption], Error>) -> Void) {
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
                    let options = responseData.originDestinationInformationList.flatMap { $0.originDestinationOptionList }
                    completion(.success(options))
                } else {
                    let errorDetail = flightResponse.message?.detail.first?.code ?? "Unknown error"
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDetail])))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "We do not have any flights on the date and route you have selected or all our flights are sold out."])))
            }
        }
        task.resume()
    }
}
