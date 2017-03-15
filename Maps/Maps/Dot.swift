//
//  Dot.swift
//  Maps
//
//  Created by Radi on 3/14/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import MapKit

enum Gender : String {
    case Unknown
    case Male
    case Female
    
    static func getGender(index: Int) -> Gender {
        switch index {
        case 0 : return Gender.Unknown
        case 1 : return Gender.Male
        default : return Gender.Female
        }
    }
}

class Dot : MKPointAnnotation {
    static private let maxLat : Double = 45.34
    static private let minLat : Double = 42.23
    
    static private let maxLon : Double = 45.23
    static private let minLon : Double = 42.23
    
    var name : String
    var tags : [String] = []
    var gender : Gender
    
    var avatar : UIImage? {
        get {
            switch self.gender {
            case .Male: return  UIImage(named: "man")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate).resizeImage(toSize: CGSize(width: 20.0, height: 20.0))
            case .Female:return  UIImage(named: "woman")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate).resizeImage(toSize: CGSize(width: 20.0, height: 20.0))
            default:return  UIImage(named: "person")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate).resizeImage(toSize: CGSize(width: 20.0, height: 20.0))
            }
        }
    }
    
    var image : UIImage? {
        get {
            switch self.gender {
            case .Male: return UIImage(named: "blue")
            case .Female: return  UIImage(named: "red")
            default: return  UIImage(named: "green")
            }
        }
    }
    
    convenience init(location: CLLocationCoordinate2D,
                     name: String) {
        self.init(location: location,
                  name: name,
                  tags: [],
                  gender: Gender.Unknown)
    }
    
    init(location: CLLocationCoordinate2D,
         name: String,
         tags: [String],
         gender: Gender) {
        self.name = name
        self.tags = tags
        self.gender = gender
        super.init()
        self.coordinate = location
        self.title = self.name
        self.subtitle = self.gender.rawValue
    }
    
    static func getRandomDots(count: Int) -> [Dot] {
        var dots : [Dot] = []
        for _ in 0..<count {
            dots.append(self.getRandomDot())
        }
        
        return dots
    }
    
    static private func getRandomDot() -> Dot {
        let location = CLLocationCoordinate2D.randomCoordinate2D(minLat: self.minLat,
                                                                 maxLat: self.maxLat,
                                                                 minLon: self.minLon,
                                                                 maxLon: self.maxLon)
        
        let name = String.randomString(length: Int(arc4random_uniform(12)))
        let gender = Gender.getGender(index: Int(arc4random_uniform(3)))
        
        var tags = [String]()
        let tagsCount = Int(arc4random_uniform(3))
        for _ in 0..<tagsCount {
            let tag = String.randomString(length: Int(arc4random_uniform(7)))
            tags.append(tag)
        }
        
        return Dot(location: location,
                   name: name,
                   tags: tags,
                   gender: gender)
    }
}

extension UIImage {
    func resizeImage(toSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = toSize.width  / self.size.width
        let heightRatio = toSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio,
                             height: size.height * heightRatio)
        }
        else {
            newSize = CGSize(width: size.width * widthRatio,
                             height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension String {
    static func randomString(length: Int) -> String {
        guard length > 0 else {
            return "blank"
        }

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

extension CLLocationCoordinate2D {
    static func randomCoordinate2D(minLat: Double, maxLat: Double, minLon: Double, maxLon: Double) -> CLLocationCoordinate2D {
        let latitude = Double.random(min: minLat, max: maxLat)
        let longitude = Double.random(min: minLon, max: maxLon)
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}


