//
//  FlightsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation

protocol PortSelectionDelegate: AnyObject {
    func didChoosePort(port: Port, forField: CustomTextField2)
}

protocol FlightsViewModelDelegate: AnyObject {
    func didUpdateFlightSegments()
    func didFailWithError(_ error: Error)
}

class FlightsViewModel: ObservableObject {
    @Published var searchedFlights: [FlightSegment] = []
    var countries: [Country] = []
    @Published var ports: [Port] = []
    let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
    
    weak var flightsDelegate: FlightsViewModelDelegate?
    
    func fetchCountries(completion: @escaping ([Country]) -> Void) {
        guard let url = URL(string: "https://www.turkishairlines.com/api/v1/booking/countries?\(currentTimeMillis)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching countries: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let countryResponse = try JSONDecoder().decode(CountryResponse.self, from: data)
                DispatchQueue.main.async {
                    self.countries = countryResponse.data.countries.flatMap { $0 }
                    completion(self.countries)
                }
            } catch {
                print("Error decoding countries: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchPorts(for countryCode: String, completion: @escaping ([Port]) -> Void) {
        guard let url = URL(string: "https://www.turkishairlines.com/api/v1/booking/countries/\(countryCode)/ports?\(currentTimeMillis)") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching ports: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let portsResponse = try JSONDecoder().decode(PportResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.ports = portsResponse.data
                    completion(portsResponse.data)
                }
            } catch {
                print("Error decoding ports: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchPortSuggestions(for query: String, completion: @escaping ([Port]) -> Void) {
        guard let url = URL(string: "https://www.turkishairlines.com/api/v1/booking/locations/TK/en?searchText=\(query)") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching port suggestions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let portsResponse = try JSONDecoder().decode(PortResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.ports = portsResponse.data.ports
                    completion(portsResponse.data.ports)
                }
            } catch {
                print("Error decoding port suggestions: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func performSearch(originPort: Port, destinationPort: Port, departureDate: String, completion: @escaping () -> Void) {
        guard !departureDate.isEmpty else {
            flightsDelegate?.didFailWithError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid search parameters"]))
            return
        }
        
        let payload = FlightSearchPayload(
            moduleType: "TICKETING",
            originDestinationInformationList: [
                OriginDestinationInformation(
                    destinationAirportCode: destinationPort.code,
                    destinationMultiPort: false,
                    originAirportCode: originPort.code,
                    departureDate: departureDate
                )
            ],
            passengerTypeList: [
                PassengerType(quantity: 1, code: "ADULT")
            ],
            selectedBookerSearch: "O",
            selectedCabinClass: "ECONOMY"
        )
        
        searchFlights(with: payload) { [weak self] result in
            switch result {
            case .success(let segments):
                self?.searchedFlights = segments
                self?.flightsDelegate?.didUpdateFlightSegments()
                print("Searched flights updated: \(self?.searchedFlights ?? [])")
            case .failure(let error):
                self?.flightsDelegate?.didFailWithError(error)
            }
        }
        completion()
    }
    
    private func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightSegment], Error>) -> Void) {
        let networkManager = NetworkManager()
        
        networkManager.searchFlights(with: payload) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
