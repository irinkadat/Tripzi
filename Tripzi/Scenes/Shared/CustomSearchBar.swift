//
//  CustomSearchBar.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 18.07.24.
//

import UIKit

class CustomSearchBar: UIView {

    private let borderLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        searchIcon.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = CustomLabel()
        titleLabel.text = "where to"
        titleLabel.style = .title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = CustomLabel()
        subtitleLabel.text = "Anywhere - Any time"
        subtitleLabel.style = .subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.tintColor = .black
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        let horizontalStackView = UIStackView(arrangedSubviews: [searchIcon, stackView, filterButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 8
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),

            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            filterButton.widthAnchor.constraint(equalToConstant: 18),
            filterButton.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        borderLayer.borderWidth = 0.5
        borderLayer.borderColor = UIColor.systemGray4.cgColor
        borderLayer.cornerRadius = 26
        borderLayer.frame = bounds
        borderLayer.masksToBounds = true
        borderLayer.shadowColor = UIColor.black.cgColor
        borderLayer.shadowOpacity = 0.4
        borderLayer.shadowOffset = CGSize(width: 0, height: 1)
        borderLayer.shadowRadius = 2
        borderLayer.masksToBounds = false

        layer.addSublayer(borderLayer)
        layer.cornerRadius = 26
        layer.masksToBounds = true

        layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
    }

    @objc private func filterButtonTapped() {
        // Action for filter button tap
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

#Preview {
    ViewController()
}
