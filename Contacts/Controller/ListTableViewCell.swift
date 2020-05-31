//
//  ListTableViewCell.swift
//  Contacts
//
//  Created by Inna Litvinenko on 28.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    private var nameLabel = UILabel()
    private var avatar =  UIImageView()
    private var statusView = UIView()
    
    var imageId = Int()
    
    func setNameLabelText(labelText: String) {
        nameLabel.text = labelText
    }
    
    func setAvatarImage(image: UIImage) {
        avatar.image = image
    }
    
    func setAvatarImage(imageURL: URL) {
        NetworkManager.downloadImage(imageURL: imageURL,  completion: { img in
            self.avatar.image = img
        })
    }
    
    func setStatus (online: Bool) {
        if online == true {
            addSubview(statusView)
        }
        else {
            statusView.removeFromSuperview()
            
        }
    }
    
    private func setupLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = "Person Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    
    private func setupAvatar()  {
        avatar.image = UIImage(systemName: "person.circle")
        avatar.tintColor = .label
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 20
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleToFill
        addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            avatar.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupStatus()  {
        statusView.backgroundColor = .systemGreen
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.frame = CGRect(x: 39, y: 31, width: 17, height: 17)
        statusView.layer.cornerRadius = 8
        statusView.layer.borderWidth = 2
        statusView.layer.borderColor = UIColor.systemBackground.cgColor
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAvatar()
        setupStatus()
        setupLabel()
    }
    

   required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
  }
}
