//
//  Donloader.swift
//  FinalProject
//
//  Created by CDMStudent on 3/17/24.
//

import Foundation
import FirebaseStorage
import UIKit


let storage = Storage.storage()

func uploadImage(Images:[UIImage?], productId:String, completion: @escaping(_ imageLinks:[String]) -> Void){
    if Reachability.HasConnection(){
        var uploadImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in Images {
            let fileName = "ProductImages/" + productId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            saveImageInFirebase(imageData: imageData!, fileName: fileName)  {
                (imageLink) in
                if imageLink != nil{
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    if uploadImagesCount == Images.count{
                        completion(imageLinkArray)
                    }
                }

            }
        }
        
    }else{
        print("No Internet Connection")
    }
}

func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink:String?) -> Void ){
    var task: StorageUploadTask!
    
    let StorageRef = storage.reference(forURL: KFirebaseStorage).child(fileName)
    
    task = StorageRef.putData(imageData, metadata: nil ,completion: { (metadata,error)
        in
        task.removeAllObservers()
        if error != nil{
            print("Error uploading Image",error?.localizedDescription)
            completion(nil)
            return
        }else{
            StorageRef.downloadURL{
                (url,error) in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        }
    })
}


func downloadImages(imageUrls: [String], completion : @escaping (_ images: [UIImage?]) -> Void){
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0
    for link in imageUrls {
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf:  url! as URL)
            
            if data != nil{
                imageArray.append(UIImage(data: data! as Data)!)
                if downloadCounter == imageArray.count{
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
            } else{
                print("Couldn't download image")
                completion(imageArray)
            }
        }
    }
    
}
