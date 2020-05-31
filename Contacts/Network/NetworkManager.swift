//
//  NetworkManager.swift
//  Contacts
//
//  Created by Inna Litvinenko on 29.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func downloadImage(imageURL: URL, completion: @escaping (UIImage) -> ()) {
       let imageUrl: URL =  imageURL
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            if let data = try? Data(contentsOf: imageUrl){
                DispatchQueue.main.async {
                    completion(UIImage(data: data) ?? UIImage())
                }
            }
        }
        
    }
}
