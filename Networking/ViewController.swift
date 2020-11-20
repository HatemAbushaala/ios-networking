//
//  ViewController.swift
//  Networking
//
//  Created by Hatem Abushaala on 11/17/20.
//  Copyright © 2020 haten. All rights reserved.
//

import UIKit


class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataRepo.basicGet(successHandler: {(res) in
            print("success response code : \(res.code) msg:\(res.msg)")
        })
        
        DataRepo.getWithSubroute(id:"TR",successHandler: {(res) in
                 print("success response code : \(res.code) msg:\(res.msg)")
             })
        
     
//        DataRepo.contact(["name":"hatem","email":"h@abushaala.com","phone":"0546464484","message":"more than 20 characters message contact from hatem"],successHandler: { (res) in
//        print("success response code : \(res.code) msg:\(res.msg)")
//      })
        
        
//        let contact  = Contact()
//          DataRepo.contact(contact,successHandler: { (res) in
//          print("success response code : \(res.code) msg:\(res.msg)")
//        })
        
        
    }

    @IBAction func btnClicked() {

         if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
             print("Button capture")

             imagePicker.delegate = self
             imagePicker.sourceType = .savedPhotosAlbum
             imagePicker.allowsEditing = false
            imagePicker.mediaTypes = ["public.image", "public.movie"]


             present(imagePicker, animated: true, completion: nil)
         }
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
         self.dismiss(animated: true, completion: { () -> Void in

         })

        
        imageView.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        let data: Data = imageView.image!.jpegData( compressionQuality: 1)! 

        
        DataRepo.uploadImage(data,successHandler: { (res) in
           print("success response code : \(res.code) msg:\(res.msg)")
         })

        
        

    }

     
    
}



