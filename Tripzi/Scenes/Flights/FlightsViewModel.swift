//
//  FlightsViewModel.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import Foundation
import Combine
import NetService

protocol PortSelectionDelegate: AnyObject {
    func didChoosePort(portName: String, forField: CustomTextField)
    func didUpdateSuggestions()
}

protocol FlightsViewModelDelegate: AnyObject {
    func didUpdateFlightSegments()
    func didFailWithError(_ error: Error)
}

class FlightsViewModel: ObservableObject {
    @Published var searchedFlights: [FlightOption] = []
    @Published var ports: [Port] = []
    @Published var errorMessage: String?
    @Published var selectedOriginPort: Port?
    @Published var selectedDestinationPort: Port?
    @Published var hasSearchedFlights: Bool = false
    
    @Published var flattenedFlights: [(FlightSegment, FlightPrice?)] = []
    var selectedFlightOption: FlightOption? {
        didSet {
            updateFlightDetails()
        }
    }
    
    @Published var departureDate: String = ""
    @Published var departureTime: String = ""
    @Published var arrivalDate: String = ""
    @Published var arrivalTime: String = ""
    @Published var departureAirportCode: String = ""
    @Published var arrivalAirportCode: String = ""
    @Published var flightDuration: String = ""
    @Published var flightPriceCurrency: String = ""
    @Published var flightPrice: Double = 0.0
    
    private var networkService = NetworkService()
    
    func selectFlightOption(at index: Int) {
        selectedFlightOption = searchedFlights[index]
    }
    
    func flattenFlights(flight: [FlightOption]) {
        flattenedFlights = searchedFlights.flatMap { option in
            option.segmentList.map { segment in
                (segment, option.startingPrice)
            }
        }
    }
    
    var countries: [Country] = []
    let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
    
    weak var flightsDelegate: FlightsViewModelDelegate?
    weak var portSelectionDelegate: PortSelectionDelegate?
    
    func fetchCountries(completion: @escaping ([Country]) -> Void) {
        let urlString = "https://www.turkishairlines.com/api/v1/booking/countries?\(currentTimeMillis)"
        
        networkService.getData(urlString: urlString) { (result: Result<CountryResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.countries = response.data.countries.flatMap { $0 }
                    completion(self.countries)
                }
            case .failure(let error):
                print("Error fetching countries: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPorts(for countryCode: String, completion: @escaping ([Port]) -> Void) {
        ports.removeAll()
        
        let urlString = "https://www.turkishairlines.com/api/v1/booking/countries/\(countryCode)/ports?\(currentTimeMillis)"
        
        networkService.getData(urlString: urlString) { (result: Result<PportResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.ports = response.data
                    completion(response.data)
                }
            case .failure(let error):
                print("Error fetching ports: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPortSuggestions(for query: String) {
        ports.removeAll()
        
        let urlString = "https://www.turkishairlines.com/api/v1/booking/locations/TK/en?searchText=\(query)"
        
        networkService.getData(urlString: urlString) { [weak self] (result: Result<PortResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.ports = response.data.ports
                    self?.portSelectionDelegate?.didUpdateSuggestions()
                }
            case .failure(let error):
                print("Error fetching port suggestions: \(error.localizedDescription)")
            }
        }
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
                self?.hasSearchedFlights = !segments.isEmpty
                self?.flattenFlights(flight: segments)
                self?.flightsDelegate?.didUpdateFlightSegments()
                print("Searched flights updated: \(self?.searchedFlights ?? [])")
                print("Flattened flights updated: \(self?.flattenedFlights ?? [])")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.flightsDelegate?.didFailWithError(error)
            }
        }
        completion()
    }
    
    private func searchFlights(with payload: FlightSearchPayload, completion: @escaping (Result<[FlightOption], Error>) -> Void) {
        let networkManager = FlightNetworkManager()
        
        networkManager.searchFlights(with: payload) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func didChoosePort(port: Port, forField: CustomTextField) {
        portSelectionDelegate?.didChoosePort(portName: port.name, forField: forField)
        
        switch forField.tag {
        case 1:
            selectedOriginPort = port
        case 2:
            selectedDestinationPort = port
        default:
            break
        }
    }
    
    func handleTextChange(newText: String) {
        if newText.isEmpty {
            ports.removeAll()
            portSelectionDelegate?.didUpdateSuggestions()
        } else {
            fetchPortSuggestions(for: newText)
        }
    }
    
    func selectPort(at index: Int, forField field: CustomTextField) {
        let selectedPort = ports[index]
        didChoosePort(port: selectedPort, forField: field)
    }
    
    private func updateFlightDetails() {
        guard let selectedFlight = selectedFlightOption,
              let startSegment = selectedFlight.segmentList.first,
              let endSegment = selectedFlight.segmentList.last else {
            return
        }
        
        let departureDateTimeComponents = startSegment.departureDateTime.split(separator: " ")
        if departureDateTimeComponents.count == 2 {
            departureDate = String(departureDateTimeComponents[0])
            departureTime = String(departureDateTimeComponents[1])
        } else {
            departureDate = startSegment.departureDateTime
            departureTime = startSegment.departureDateTime
        }
        
        let arrivalDateTimeComponents = endSegment.arrivalDateTime.split(separator: " ")
        if arrivalDateTimeComponents.count == 2 {
            arrivalDate = String(arrivalDateTimeComponents[0])
            arrivalTime = String(arrivalDateTimeComponents[1])
        } else {
            arrivalDate = endSegment.arrivalDateTime
            arrivalTime = endSegment.arrivalDateTime
        }
        
        departureAirportCode = startSegment.departureAirportCode
        arrivalAirportCode = endSegment.arrivalAirportCode
        flightDuration = "Duration: \(startSegment.journeyDurationInMillis / 60000) mins"
        if let price = selectedFlight.startingPrice {
            flightPrice = price.amount
            flightPriceCurrency = price.currencyCode
        } else {
            flightPrice = 0.0
            flightPriceCurrency = "USD"
        }
    }
}
