//
//  GridCollectionViewCell.swift
//  Contacts
//
//  Created by Inna Litvinenko on 30.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    private var avatar =  UIImageView()
    private var statusView = UIView()
    
    private func setupAvatar()  {
        avatar.image = UIImage(systemName: "person.circle")
        avatar.tintColor = .label
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 20
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleToFill
        addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            avatar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupStatus()  {
        statusView.backgroundColor = .systemGreen
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.frame = CGRect(x: 30, y: 30, width: 17, height: 17)
        statusView.layer.cornerRadius = 8
        statusView.layer.borderWidth = 2
        statusView.layer.borderColor = UIColor.systemBackground.cgColor
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

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAvatar()
        setupStatus()
        addSubview(statusView)
    }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
