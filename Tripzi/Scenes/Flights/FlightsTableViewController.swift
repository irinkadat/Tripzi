//
//  FlightsTableViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 10.07.24.
//

import UIKit

// MARK: - aq tvitmprinavis animacia minda

class FlightsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FlightTableViewCell.self, forCellReuseIdentifier: FlightTableViewCell.identifier)
        return tableView
    }()
    
    private let flights: [FlightInfoModel] = [
        FlightInfoModel(departureDate: "კვი, 14, ივლ, 2024", departureTime: "22:15", flightDuration: "3სთ 30წთ", flightDetail: "Wizz Air Malta", arrivalTime: "03:45"),
        FlightInfoModel(departureDate: "კვი, 14, ივლ, 2024", departureTime: "22:15", flightDuration: "3სთ 30წთ", flightDetail: "Wizz Air Malta", arrivalTime: "03:45"),
        FlightInfoModel(departureDate: "კვი, 14, ივლ, 2024", departureTime: "22:15", flightDuration: "3სთ 30წთ", flightDetail: "Wizz Air Malta", arrivalTime: "03:45"),
        FlightInfoModel(departureDate: "კვი, 14, ივლ, 2024", departureTime: "22:15", flightDuration: "3სთ 30წთ", flightDetail: "Wizz Air Malta", arrivalTime: "03:45")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        cell.configure(with: flights[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

#Preview {
    FlightsTableViewController()
}
