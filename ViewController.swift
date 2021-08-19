//
//  ViewController.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
// Sources: UIKit Apprentice textbook, www.youtube.com,
// https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
// https://github.com/josejuanqm/Ody
// https://github.com/thellimist/SwiftRandom
// https://stackoverflow.com/questions/26207846/pass-data-through-segue
// https://stackoverflow.com/questions/30929986/how-to-apply-multiple-transforms-in-swift
// https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
//https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift
// https://stackoverflow.com/questions/48736485/save-uiimage-to-userdefault-as-array-swift

import UIKit
import AVFoundation


//Delegate Protocol
protocol LikedPicturesDelegate:class {
    func deleteFavourite(_ controller: LikedPicturesVC, images: [UIImage])
    
}

class ViewController: UIViewController, LikedPicturesDelegate {
    
    //Outlets initialized connected to the main.storyboard's Viewcontroller
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var catsImage: UIImageView!
    @IBOutlet weak var animateCartoon: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    //index for the images
    var index:Int?
    
    var i=Int()

    
    //array of object Cat from CatsModel
    var arry = [cats.Cat]()
    
    var imageArray = [UIImage]()
    var backgroundImages = [UIImage(named: "image1"),UIImage(named: "image2")]
   
    
    //for sound setup
    let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: "LikedSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // getting data from server and appending it to our local array
        catsManager.instance.getData { (result) in
            self.arry = result ?? []
            self.index = 0
            
            let url = URL(string: (self.arry[self.index!].image?.url)!)
            self.downloadImage(from: url!)
            self.index! += 1
        }
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(positionChange), userInfo: nil, repeats: true)
        
    }
    
    func deleteFavourite(_ controller: LikedPicturesVC, images: [UIImage]) {
        UserDefaults.standard.set(images, forKey: "images")
       
        
    }
    

    // Performing segue for sending data to likedPicturesVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favourites" {
            if let nextViewController = segue.destination as? LikedPicturesVC {
                nextViewController.delegate = self
            }
        }
    }
    
    
    @objc func positionChange(){
        let randomInt = Int.random(in: 1..<500)
        let destination = view.convert(catsImage.center, from: catsImage.superview)
        animateCartoon.move(to: destination.applying(
                            CGAffineTransform(translationX: CGFloat(Int(randomInt)), y: CGFloat(Int(randomInt)))),
                          duration: 1.0,
                          options: .curveEaseIn)
        
    }
    
    @IBAction func likeButton(_ sender: Any) {
        
        
        // checking codition if an image already exists in the favourite, if not then save to the collection in that screen
        if imageArray.contains(catsImage.image!){
            
        }else {
            imageArray.append(catsImage.image!)
            UserDefaults.standard.set(imageArray, forKey: "images")
        }
        
        
        // Playing the sound when like button is clicked
       do {
        audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
            audioPlayer.play()
        } catch {
            
        }
        
    }
    
    
    @IBAction func reloadButton(_ sender: Any) {
        
        
     
        //the last element of our array
        let lastIndex = self.arry.count - 1
        
        //checking condition if the index of array is equals to our last index then return back to first image repeat the process.
        if self.index! == lastIndex {
            self.index = 0
        }else {
            self.index! += 1
        }
        
        // checking if the url of image does not exits in the array then return with no image whether show images
        if arry[self.index!].image?.url != nil {
            let url = URL(string: (self.arry[self.index!].image?.url)!)
            self.downloadImage(from: url!)
        }else {
            catsImage.image = UIImage(named: "NoImage")
        }
        
    }
    
    
    
    // the function for loading the images URL
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //the function for loading the images URL
    func downloadImage(from url: URL) {
        print("Download Started")
        DispatchQueue.main.async {
            self.activity.startAnimating()
        }
        //self.activity.startAnimating()
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                self.activity.isHidden = true
            }
            //self.activity.isHidden = true
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.catsImage.image = UIImage(data: data)
                
            }
        }
    }
    
}




//Saving the images in fouvrite locally 
extension UserDefaults {
    func imageArray(forKey key: String) -> [UIImage]? {
        guard let array = self.array(forKey: key) as? [Data] else {
            return nil
        }
        return array.compactMap() { UIImage(data: $0) }
    }
    
    func set(_ imageArray: [UIImage], forKey key: String) {
        self.set(imageArray.compactMap({ $0.pngData() }), forKey: key)
    }
}


extension UIView {

  func move(to destination: CGPoint, duration: TimeInterval,
            options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
      self.center = destination
    }, completion: nil)
  }

}
