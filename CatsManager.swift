//
//  CatsManager.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
//  Sources: UIKit Apprentice textbook, www.youtube.com, https://stackoverflow.com/questions/43048120/swift-return-data-from-urlsession
//  https://grokswift.com/completion-handler-faqs/
//  https://learnappmaking.com/escaping-closures-swift/

import Foundation

class catsManager {
    static let instance = catsManager()
    
    
    func getData(completionBlock : @escaping (_ Success: [cats.Cat]?)->()){
        let session = URLSession.shared
                let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
                let task = session.dataTask(with: url, completionHandler: { data, response, error in
                    // Check the response
                    print(response ?? "This is a response")
                    
                    // Check if an error occured
                    if error != nil {
                        // HERE you can manage the error
                        print(error ?? "This is an error")
                        return
                    }
                    
                    // Serialize the data into an object
                    do {
                        let json = try JSONDecoder().decode([cats.Cat].self, from: data! )
                            //try JSONSerialization.jsonObject(with: data!, options: [])
                        print(json)
                        
                        completionBlock(json)
                    } catch {
                        print("Error during JSON serialization: \(error.localizedDescription)")
                    }
                  
                    
                })
                task.resume()
    }
    
}
