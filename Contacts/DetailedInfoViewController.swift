//
//  DetailedInfoViewController.swift
//  Contacts
//
//  Created by Inna Litvinenko on 29.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class DetailedInfoViewController: UIViewController {
    
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var statusLabel = UILabel()
    var emailLabel = UILabel()
    
    var contact = Contact(name: "Person Name", isOnline: true, email: "friend@gmail.com", avatarURLString: "default", id: -1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUI() {
        view.backgroundColor = .systemBackground
        //force
        setupImage(imageURL: URL(string: contact.avatarURLString + "&s=250")!)
        setupName(name: contact.name)
        setupStatus(isOnline: contact.isOnline)
        setupEmail(email: contact.email)
    }
    
    func setupImage(imageURL: URL) {
        avatarImageView.image = UIImage(systemName: "person.circle")
        NetworkManager.downloadImage(imageURL: imageURL) { img in
            self.avatarImageView.image = img
        }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 125
        view.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 250),
            avatarImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupName(name: String) {
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupStatus(isOnline: Bool) {
        statusLabel.text = isOnline ? "online" : "offline"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupEmail(email: String) {
        emailLabel.text = email
        emailLabel.numberOfLines = 0
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textAlignment = .center
        emailLabel.textColor = .systemBlue
        emailLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    

}
