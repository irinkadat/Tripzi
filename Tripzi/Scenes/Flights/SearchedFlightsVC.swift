//
//  ViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import UIKit

class SearchedFlightsVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()
    
    private var flights = [FlightModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        flights = [
            FlightModel(time: "21:05", route: "TBS - IST - CDG", duration: "14h 30m", price: "USD 325.70"),
            FlightModel(time: "21:05", route: "TBS - IST - CDG", duration: "16h 00m", price: "USD 325.70"),
            FlightModel(time: "21:05", route: "TBS - IST - CDG", duration: "17h 35m", price: "USD 325.70"),
            FlightModel(time: "21:05", route: "TBS - IST - CDG", duration: "20h 05m", price: "USD 325.70"),
        ]
    }
}

extension SearchedFlightsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.configure(with: flights[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

#Preview {
    SearchedFlightsVC()
}
