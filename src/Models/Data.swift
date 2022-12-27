//
//  Data.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI

let storeData: [Store] = load("store.json")
let commentData: [Comment] = load("comment.json")
let userInfoData: [UserInfo] = load("userInfo.json")
let clickDicData: [Category:Int]=[Category.type1:1,Category.type2:1,Category.type3:1,Category.type4:1,Category.type5:1]
let ddd : Bool = initMyself()



func getImageFromCache(str:String) -> Image {
     let filename = getDocumentsDirectory().appendingPathComponent("\(str).jpg")
     
     let imgData = try! Data.init(contentsOf: filename)
     return Image(uiImage: UIImage(data: imgData)!)
    
        //self.getImage.append(Image(uiImage: t))
 }

func loadImageInToCache(str:String, uploadImg:UIImage){
    let filename = getDocumentsDirectory().appendingPathComponent("\(str).jpg")
    if let data = uploadImg.jpegData(compressionQuality: 0.8) {
        try? data.write(to: filename)
    }
    

   /* if FileManager.default.fileExists(atPath: filename.path) {
        print("hhh")
    } else {
         print("no")
    }*/
    
    print("\(str) has load into cache")
}



func initMyself() -> Bool{
    print("init sucess")
    
    let sanboxfilename = getDocumentsDirectory().appendingPathComponent("store.json")

    
    if FileManager.default.fileExists(atPath: sanboxfilename.path) {
       return true
    }
    for s in storeData {
        for k in 0..<s.imageName.count {
            let imageNameStd = s.imageName[k]
            
            
            
           /* let filename = getDocumentsDirectory().appendingPathComponent("\(imageNameStd).jpg")
            if FileManager.default.fileExists(atPath: filename.path) {
                continue
            }*/
            
            let path = Bundle.main.path(forResource: imageNameStd, ofType: "jpg")
            let newImage = UIImage(contentsOfFile: path!)!
            loadImageInToCache(str: imageNameStd, uploadImg: newImage)
        }
        
    }
    
    for s in commentData {
        for k in 0..<s.commentImageName.count {
            let imageNameStd = s.commentImageName[k]
            
            /*let filename = getDocumentsDirectory().appendingPathComponent("\(imageNameStd).jpg")
            if FileManager.default.fileExists(atPath: filename.path) {
                continue
            }*/
            
            let path = Bundle.main.path(forResource: imageNameStd, ofType: "jpg")
            let newImage = UIImage(contentsOfFile: path!)!
            loadImageInToCache(str: imageNameStd, uploadImg: newImage)
        }
        
    }
    
    
    return true
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    /*
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
     else {
         fatalError("Couldn't find \(filename) in main bundle.")
     }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    
    
    let sanboxfilename = getDocumentsDirectory().appendingPathComponent(filename)
    let encoder = JSONEncoder()
    do  {
        // 将player对象encod（编码）
        //let data: Data = try encoder.encode(self.userData.stores)
        //let filename = getDocumentsDirectory().appendingPathComponent("store.json")
        try? data.write(to: sanboxfilename)
    } catch {
        
    }
    */
    
let sanboxfilename = getDocumentsDirectory().appendingPathComponent(filename)
    
    if FileManager.default.fileExists(atPath: sanboxfilename.path) {
        data = try! Data.init(contentsOf: sanboxfilename)
    } else {
         guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
         else {
             fatalError("Couldn't find \(filename) in main bundle.")
         }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
  

    
    
    
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


final class ImageStore {
    typealias _ImageDictionary = [String: Image]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return images.values[index]
    }

    static func loadImage(name: String) -> Image {
        /*guard
            let url = Bundle.main.url(forResource: name,withExtension: "jpg")
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        guard
            
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil)
            
            
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        guard
            
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }*/
        
        
        //return image
        return getImageFromCache(str:name)
        
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        //if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

/*
final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> Image {
        /*guard
            let url = Bundle.main.url(forResource: name,withExtension: "jpg")
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        guard
            
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil)
            
            
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        guard
            
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }*/
        
        
        //return image
        return getImageFromCache(str:name)
        
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

*/
