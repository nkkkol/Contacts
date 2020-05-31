//
//  ViewController.swift
//  Contacts
//
//  Created by Inna Litvinenko on 5/14/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let segment = UISegmentedControl(items: ["List", "Grid"])
    let listTableView = UITableView()
    var gridCollectionView =  UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    let button = UIButton()
    var downloadedImages = [String:UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.prefetchDataSource = self
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.prefetchDataSource = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "anotherCell")
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    func setupUI() {
        setupSegment()
        setupButton()
        setupCollectionView()
        setupTableView()
        view.backgroundColor = .systemBackground
    }
    
    @objc func segmentValueChanged() {
        if segment.selectedSegmentIndex == 0 {
            listTableView.isHidden = false
            gridCollectionView.isHidden = true
        }
        else {
            listTableView.isHidden = true
            gridCollectionView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupSegment() {
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        view.addSubview(segment)
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segment.widthAnchor.constraint(equalToConstant: 230),
            segment.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupTableView() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 0),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            listTableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 0)
        ])
    }
    
    func setupButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Simulate Changes", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(simulateChanges), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 100),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func setupCollectionView() {
        gridCollectionView.backgroundColor = .systemBackground
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridCollectionView)
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 0),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            gridCollectionView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 0)
        ])
        gridCollectionView.isHidden = true
    }
    
    @objc func simulateChanges() {
        ContactsDataManager.changeContactsCount(newCount: Int.random(in: 1 ... 500))
        downloadedImages = [String:UIImage]()
        listTableView.reloadData()
        gridCollectionView.reloadData()
    }
    
    func downloadImg(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] == nil {
                NetworkManager.downloadImage(imageURL: URL(string: ContactsDataManager.contacts[indexPath.row].avatarURLString)!,  completion: {
                    image in
                    self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] = image
                })
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell
        cell?.selectionStyle = .none
        cell?.setStatus(online: ContactsDataManager.contacts[indexPath.row].isOnline)
        cell?.setNameLabelText(labelText: ContactsDataManager.contacts[indexPath.row].name)
        if self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] != nil {
            DispatchQueue.main.async {
                cell?.setAvatarImage(image: self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] ?? UIImage())
            }
        }
        else {
             DispatchQueue.main.async {
            cell?.setAvatarImage(image: UIImage(systemName: "person.circle")!)
            }
            NetworkManager.downloadImage(imageURL: URL(string: ContactsDataManager.contacts[indexPath.row].avatarURLString)!,  completion: {
                image in
                self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] = image
            })
            cell?.setAvatarImage(imageURL: URL(string: ContactsDataManager.contacts[indexPath.row].avatarURLString)!)
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsDataManager.contactsCount
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = DetailedInfoViewController()
        newViewController.contact = ContactsDataManager.contacts[indexPath.row]
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}


extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        downloadImg(indexPaths: indexPaths)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ContactsDataManager.contactsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "anotherCell", for: indexPath as IndexPath) as? GridCollectionViewCell
        cell?.setStatus(online: ContactsDataManager.contacts[indexPath.row].isOnline)
        if self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] != nil {
                 DispatchQueue.main.async {
                     cell?.setAvatarImage(image: self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] ?? UIImage())
                 }
             }
             else {
                  DispatchQueue.main.async {
                 cell?.setAvatarImage(image: UIImage(systemName: "person.circle")!)
                 }
             NetworkManager.downloadImage(imageURL: URL(string: ContactsDataManager.contacts[indexPath.row].avatarURLString)!,  completion: {
            image in
            self.downloadedImages[ContactsDataManager.contacts[indexPath.row].avatarURLString] = image
        })
        cell?.setAvatarImage(imageURL: URL(string: ContactsDataManager.contacts[indexPath.row].avatarURLString)!)
             }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let newViewController = DetailedInfoViewController()
           newViewController.contact = ContactsDataManager.contacts[indexPath.row]
           self.navigationController?.pushViewController(newViewController, animated: true)
           
       }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        downloadImg(indexPaths: indexPaths)
    }
    
    
}
