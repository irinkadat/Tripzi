//
//  ProfileVC.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var subtitleLabel: UILabel!
    var editPhotoButton: UIButton!
    private var profileViewModel = ProfileViewModel()
    private var authManager = AuthenticationManager()
    private var authStateListener: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        setupAuthStateListener()
        profileViewModel.updateUI = { [weak self] in
            self?.displayUserInfo()
        }
        profileViewModel.fetchUserInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.fetchUserInfo()
    }

    private func configureNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.profileViewModel.fetchUserInfo()
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textAlignment = .left
        nameLabel.text = "Loading Name..."
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nameLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .gray
        subtitleLabel.text = "Show profile"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)
        
        editPhotoButton = UIButton(type: .system)
        editPhotoButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editPhotoButton.addTarget(self, action: #selector(editPhotoTapped), for: .touchUpInside)
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(editPhotoButton)
        
        let settingsView = UIView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsView)
        
        let settingsTitleLabel = UILabel()
        settingsTitleLabel.text = "Settings"
        settingsTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        settingsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsView.addSubview(settingsTitleLabel)
        
        let personalInfoButton = createSettingsButton(title: "Personal information", icon: UIImage(systemName: "person.circle"))
        personalInfoButton.addTarget(self, action: #selector(personalInfoButtonTapped), for: .touchUpInside)
        
        let paymentsButton = createSettingsButton(title: "Payments and payouts", icon: UIImage(systemName: "creditcard"))
        let aboutUs = createSettingsButton(title: "About Tripz", icon: UIImage(systemName: "doc.text"))
        let securityButton = createSettingsButton(title: "Login & security", icon: UIImage(systemName: "shield"))
        
        let logoutButton = createSettingsButton(title: "Log out", icon: UIImage(systemName: "door.left.hand.open"))
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

        let settingsStackView = UIStackView(arrangedSubviews: [personalInfoButton, paymentsButton, aboutUs, securityButton, logoutButton])
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 20
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.addSubview(settingsStackView)
        
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
            
            settingsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            settingsTitleLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            settingsTitleLabel.topAnchor.constraint(equalTo: settingsView.topAnchor),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsTitleLabel.bottomAnchor, constant: 10),
            settingsStackView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            settingsStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -20),
            settingsStackView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -20)
        ])
    }

    private func createSettingsButton(title: String, icon: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    @objc private func personalInfoButtonTapped() {
        let personalInfoVC = PersonalInfoViewController()
        navigationController?.pushViewController(personalInfoVC, animated: true)
    }

    private func displayUserInfo() {
        if Auth.auth().currentUser != nil {
            nameLabel.text = profileViewModel.userName ?? "No Name"
            
            if let userImage = profileViewModel.userImage {
                imageView.image = userImage
            } else {
                imageView.image = UIImage(systemName: "person.circle")
            }
        } else {
            nameLabel.text = "No User Logged In"
            imageView.image = UIImage(systemName: "person.circle")
        }
    }

    @objc func editPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
            profileViewModel.updateProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            profileViewModel.updateProfileImage(originalImage)
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func handleLogout() {
        authManager.signOut()
        let loginVC = AuthenticationVC()
        loginVC.modalPresentationStyle = .popover
        present(loginVC, animated: true)
    }
    
    func refreshUserInfo() {
        profileViewModel.fetchUserInfo()
    }

    private func presentLoginScreen() {
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate {
            sceneDelegate.resetToLoginScreen()
        }
    }
}


#Preview {
    ProfileVC()
}
