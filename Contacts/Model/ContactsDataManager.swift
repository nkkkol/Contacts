//
//  ContactsDataManager.swift
//  Contacts
//
//  Created by Inna Litvinenko on 28.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class ContactsDataManager {
    
    private static let hasher = Hasher()
    static var contactsCount = Int.random(in: 1 ... 500)
    
    static func changeContactsCount(newCount: Int) {
        contactsCount = newCount
        contacts = setContacts()
    }
    
    static var contacts : [Contact] = { () -> [Contact] in
        return setContacts()
    }()
    
    static private func setContacts() -> [Contact] {
        var contactsList = [Contact]()
        contactsList.append(Contact(name: "Inna",
                                    isOnline: Bool.random(),
                                    email: "lytvynenko@stud.onu.edu.ua",
                                    avatarURLString: getAvatarUrlString(email: "lytvynenko@stud.onu.edu.ua"),
                                    id: 0))
               
        for iterator in 1...contactsCount {
            let name = "Friend " + String(iterator)
            let email = "friend" + String(iterator) + "@gmail.com"
            contactsList.append(Contact(name: name,
                                        isOnline: Bool.random(),
                                        email: email,
                                        avatarURLString: getAvatarUrlString(email: email),
                                        id: iterator))
        }
       contactsList.shuffle()
       return contactsList
    }
    
    private static func getAvatarUrlString(email: String) -> String {
        let md5Data = hasher.MD5(string: email)
        let md5Email =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return "https://www.gravatar.com/avatar/" + md5Email + "?d=retro"
    }

    
}
