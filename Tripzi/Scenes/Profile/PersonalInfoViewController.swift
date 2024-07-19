//
//  PersonalInfoViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit
import FirebaseAuth

class PersonalInfoViewController: UIViewController {
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var birthdateLabel: UILabel!
    private var profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileViewModel.updateUI = { [weak self] in
            self?.displayUserInfo()
        }
        profileViewModel.fetchUserInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let nameLabels = createInfoLabels(title: "Name:", value: "Loading Name...")
        nameLabel = nameLabels.valueLabel
        view.addSubview(nameLabels.titleLabel)
        view.addSubview(nameLabels.valueLabel)
        
        let emailLabels = createInfoLabels(title: "Email:", value: "Loading Email...")
        emailLabel = emailLabels.valueLabel
        view.addSubview(emailLabels.titleLabel)
        view.addSubview(emailLabels.valueLabel)
        
        let birthdateLabels = createInfoLabels(title: "Birthdate:", value: "Loading Birthdate...")
        birthdateLabel = birthdateLabels.valueLabel
        view.addSubview(birthdateLabels.titleLabel)
        view.addSubview(birthdateLabels.valueLabel)
        
        setupConstraints(labels: nameLabels, topAnchor: view.safeAreaLayoutGuide.topAnchor, topConstant: 20)
        setupConstraints(labels: emailLabels, topAnchor: nameLabels.titleLabel.bottomAnchor, topConstant: 20)
        setupConstraints(labels: birthdateLabels, topAnchor: emailLabels.titleLabel.bottomAnchor, topConstant: 20)
    }
    
    private func createInfoLabels(title: String, value: String) -> (titleLabel: UILabel, valueLabel: UILabel) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.textAlignment = .left
        valueLabel.text = value
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return (titleLabel, valueLabel)
    }
    
    private func setupConstraints(labels: (titleLabel: UILabel, valueLabel: UILabel), topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        NSLayoutConstraint.activate([
            labels.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            labels.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labels.titleLabel.widthAnchor.constraint(equalToConstant: 80),
            
            labels.valueLabel.centerYAnchor.constraint(equalTo: labels.titleLabel.centerYAnchor),
            labels.valueLabel.leadingAnchor.constraint(equalTo: labels.titleLabel.trailingAnchor, constant: 10),
            labels.valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func displayUserInfo() {
        if let user = Auth.auth().currentUser {
            nameLabel.text = profileViewModel.userName ?? "No Name"
            emailLabel.text = user.email ?? "No Email"
            
            if let birthDate = profileViewModel.userBirthDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                birthdateLabel.text = dateFormatter.string(from: birthDate)
            } else {
                birthdateLabel.text = "No Birthdate"
            }
        } else {
            nameLabel.text = "No User Logged In"
            emailLabel.text = "No Email"
            birthdateLabel.text = "No Birthdate"
        }
    }
}

#Preview {
    PersonalInfoViewController()
}
