//
//  ProfileVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import FirebaseAuth
import Combine

final class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let subtitleLabel = UILabel()
    let editPhotoButton = UIButton(type: .system)
    private let profileViewModel = ProfileViewModel()
    private var authButton: UIButton!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        setupBindings()
        profileViewModel.fetchUserInfoIfNeeded(forceFetch: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.fetchUserInfoIfNeeded()
    }
    
    // MARK: - Configuration

    private func configureNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewModel.cleanup()
    }
    
    private func setupBindings() {
        profileViewModel.bindProfileUI(nameLabel: nameLabel, imageView: imageView, authButton: authButton)
    }
    
    private func setupUI() {
        view.backgroundColor = .uniBackground
        setupHeaderView()
        setupSettingsView()
        setupHeaderConstraints()
        setupSettingsConstraints()
    }
    
    // MARK: - Header View
    
    private func setupHeaderView() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "nouser")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(imageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textAlignment = .left
        nameLabel.text = "Loading Name..."
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nameLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .gray
        subtitleLabel.text = "Show profile"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)
        
        editPhotoButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editPhotoButton.addAction(UIAction(handler: {_ in self.editPhotoTapped()}), for: .touchUpInside)
        
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(editPhotoButton)
    }
    
    // MARK: - Settings View
    
    private func setupSettingsView() {
        let settingsView = createSettingsViewContainer()
        let settingsTitleLabel = createSettingsTitleLabel()
        let settingsStackView = createSettingsStackView()
        
        settingsView.addSubview(settingsTitleLabel)
        settingsView.addSubview(settingsStackView)
        view.addSubview(settingsView)
    }
    
    private func createSettingsViewContainer() -> UIView {
        let settingsView = UIView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        return settingsView
    }
    
    private func createSettingsTitleLabel() -> UILabel {
        let settingsTitleLabel = UILabel()
        settingsTitleLabel.text = "Settings"
        settingsTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        settingsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsTitleLabel
    }
    
    private func createSettingsStackView() -> UIStackView {
        let personalInfoButton = createSettingsButton(title: "Personal information", icon: UIImage(named: "person"))
        personalInfoButton.addAction(UIAction(handler: { _ in self.personalInfoButtonTapped() }), for: .touchUpInside)
        
        let paymentsButton = createSettingsButton(title: "Payments and payouts", icon: UIImage(named: "card"))
        paymentsButton.addAction(UIAction(handler: { _ in self.paymentInfoButtonTapped() }), for: .touchUpInside)
        
        let aboutUsButton = createSettingsButton(title: "About Tripz", icon: UIImage(named: "about"))
        aboutUsButton.addAction(UIAction(handler: { _ in self.aboutUsButtonTapped() }), for: .touchUpInside)
        
        authButton = createSettingsButton(title: "Loading...", icon: UIImage(named: "door"))
        authButton.addAction(UIAction(handler: {_ in self.handleAuthButtonTapped()}), for: .touchUpInside)
        
        let settingsStackView = UIStackView(arrangedSubviews: [personalInfoButton, paymentsButton, aboutUsButton, authButton])
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 20
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        return settingsStackView
    }
    
    // MARK: - Constraints

    private func setupHeaderConstraints() {
        guard let headerView = view.subviews.first else { return }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: editPhotoButton.leadingAnchor, constant: -10),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(equalTo: editPhotoButton.leadingAnchor, constant: -10),
            
            editPhotoButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            editPhotoButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            editPhotoButton.widthAnchor.constraint(equalToConstant: 20),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupSettingsConstraints() {
        guard let settingsView = view.subviews.last,
              let settingsTitleLabel = settingsView.subviews.first,
              let settingsStackView = settingsView.subviews.last else { return }
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.subviews.first!.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            settingsTitleLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            settingsTitleLabel.topAnchor.constraint(equalTo: settingsView.topAnchor),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsTitleLabel.bottomAnchor, constant: 16),
            settingsStackView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            settingsStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -20),
            settingsStackView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Helper Methods

    private func createSettingsButton(title: String, icon: UIImage?) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.image = icon
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .uniCo
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }
    
    private func aboutUsButtonTapped() {
        let aboutVC = AboutVC()
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    private func paymentInfoButtonTapped() {
        let paymentsVC = PaymentsVC()
        navigationController?.pushViewController(paymentsVC, animated: true)
    }
    
    private func personalInfoButtonTapped() {
        let personalInfoVC = PersonalInfoViewController()
        navigationController?.pushViewController(personalInfoVC, animated: true)
    }
    
    func editPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            if let image = self?.profileViewModel.handlePickedImage(info: info) {
                self?.imageView.image = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func handleAuthButtonTapped() {
        profileViewModel.handleAuthButtonTap { [weak self] in
            DispatchQueue.main.async {
                let loginVC = AuthenticationVC()
                loginVC.modalPresentationStyle = .popover
                self?.present(loginVC, animated: true)
            }
        }
    }
}

#Preview {
    ProfileVC()
}
