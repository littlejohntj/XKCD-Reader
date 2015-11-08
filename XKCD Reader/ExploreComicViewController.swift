//
//  ExploreComicViewController.swift
//  XKCD Reader
//
//  Created by Todd Littlejohn on 11/8/15.
//  Copyright © 2015 Todd Littlejohn. All rights reserved.
//

import UIKit

var arrayOfFavoriteComics:[String] = [String]()
var arrayOfFavoriteComicTitles:[String] = [String]()
var arrayOfFavoriteComicNumbers:[Int] = [Int]()
var arrayOfFavoriteComicAltTexts:[Int] = [Int]()

class ExploreComicViewController: UIViewController, UIScrollViewDelegate {

    // MARK: UI Outlets 
    
    @IBOutlet weak var diceButton: UIButton!
    
    @IBOutlet weak var rightArrowButton: UIButton!
    
    @IBOutlet weak var leftArrowButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var heart: UIImageView!
    
    // MARK: Class Variables
    
    var currentComicImageURL:String?
    var currentComicTitleString:String?
    var comicNumber:Int!
    var currentComicAltText = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up"
    
    var heartAnimating:Bool = false
    var whiteLayerUp = false
    
    var count = 0
    var timer = NSTimer()
    
    // MARK: Class Functions 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heart.alpha = 0.0
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.userInteractionEnabled = true
        
        self.leftArrowButton.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
        
        generateRandom()
        loadAComic(self.comicNumber)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let favComics = defaults.objectForKey("favComics") as? [String] {
            arrayOfFavoriteComics = favComics
        }
        if let favComicTitles = defaults.objectForKey("favComicTitles") as? [String] {
            arrayOfFavoriteComicTitles = favComicTitles
        }
        if let favComicNumbers = defaults.objectForKey("favComicNumbers") as? [Int] {
            arrayOfFavoriteComicNumbers = favComicNumbers
        }
        
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        view.addGestureRecognizer(tapGesture)
        
    }

    func handleTapGesture(tapGesture:UITapGestureRecognizer) {
        print("tap")
        }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func animateHeart() {
        if heartAnimating == false {
            heartAnimating = true
            
            heart.alpha = 1.0
            timer =  NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
        }
    }
    
    func counting() {
        count++
        if count >= 50 {
            self.heart.alpha = heart.alpha - 0.02
        }
        
        if count == 100 {
            timer.invalidate()
            heartAnimating = false
            count = 0
        }
    }
    
    func loadAComic(number: Int) {
        var urlContent:NSString?
        
        let comicNumber = number
        
        var comicTitleString:String?
        
        let comNum = String(comicNumber)
        
        let url = NSURL(string: "https://xkcd.com/\(comNum)/info.0.json")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
            
            if error == nil {
                
            urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
            print(urlContent!)
                
            
//                urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                
//                if (urlContent?.containsString("404 - Not Found") == false){
//                    comicTitleString = self.getComicTitle(urlContent!)
//                    
//                    let imageString = self.getComicImageString(urlContent!)
//                    self.currentComicImageURL = imageString
//                    if let _ = NSURL(string: imageString) {
//                        dispatch_async(dispatch_get_main_queue()) {
//                            self.imageURL.kf_setImageWithURL(NSURL(string: imageString)!)
//                            self.setComicTitle(comicTitleString!)
//                            self.currentComicTitleString = comicTitleString!
//                            self.setComicStar()
//                        }
//                    }
//                } else {
//                    self.presentAlert("Could Not Load",alertMessage: "Comic could not be loaded. Check your connection.")
//                }
            } else {
                print(error)
                print("#")
                self.presentAlert("Could Not Load",alertMessage: "Comic could not be loaded. Check your connection.")
                
            }
            
        }
        
        task.resume()
    }
    
    func presentAlert(title: String, alertMessage: String) {
        let alertController = UIAlertController(title: title, message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setComicTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func generateRandom() {
        let randomNumber = Int(arc4random_uniform(1580))
        self.comicNumber = randomNumber
    }
    
    func persistData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(arrayOfFavoriteComics, forKey: "favComics")
        defaults.setObject(arrayOfFavoriteComicTitles, forKey: "favComicTitles")
        defaults.setObject(arrayOfFavoriteComicNumbers, forKey: "favComicNumbers")
    }
    
    
}
