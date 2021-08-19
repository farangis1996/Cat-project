//
//  DetailBreedVC.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
//

import UIKit

class DetailBreedVC: UIViewController {
    
    
    var detail = String()
    var imageUrl = String()
    
    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedDetail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageUrl)
        self.downloadImage(from: url!)
        self.breedDetail.text = detail
       
    }
    
    
    
    
    //getting the url of image and converting into imageview
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.breedImage.image = UIImage(data: data)
            }
        }
    }
    
}
