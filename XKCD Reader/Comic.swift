//
//  Comic.swift
//  XKCD Reader
//
//  Created by Todd Littlejohn on 11/8/15.
//  Copyright © 2015 Todd Littlejohn. All rights reserved.
//

import Foundation

class Comic {
    var month: String?
    var year: String?
    var day: String?
    var num: String?
    var title: String?
    var transcript: String?
    var alt: String?
    var imageString :String?
    
    init(jsonString: String) {
        
        if let json = convertStringToDictionary(jsonString) {
        if let month = json["month"] as? String {
            self.month = month
        }
        if let year = json["year"] as? String {
            self.year = year
        }
        if let day = json["day"] as? String {
            self.day = day
        }
        if let num = json["num"] as? String {
            self.num = num
        }
        if let title = json["safe_title"] as? String {
            self.title = title
        }
        if let transcript = json["transcript"] as? String {
            self.transcript = transcript
        }
        if let alt = json["alt"] as? String {
            self.alt = alt
        }
        if let imageString = json["img"] as? String {
            self.imageString = imageString
        }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

class Repo {
    
    var name: String?
    var full_name: String?
    var http_url: String?
    
    init(json: NSDictionary) {
        if let n = json["name"] as? String {
            self.name = n
        }
        if let f = json["full_name"] as? String {
            self.full_name = f
        }
        if let h = json["http_url"] as? String {
            self.http_url = h
        }
    }
}