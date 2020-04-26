//
//  PictureIdViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 31/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class PictureIdViewController: BaseViewController {
    
  @IBOutlet weak var candidateCapturedImage: UIImageView!
  @IBOutlet weak var noImagesData: UILabel!
  var imageUrl = ""
  var candidateName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpNavigationBar()
        noImagesData.light(size: 18)
        if(imageUrl != "") {
            self.candidateCapturedImage.isHidden = false
              self.candidateCapturedImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "NoImage"))
              self.noImagesData.isHidden = true
//            self.candidateCapturedImage.layer.cornerRadius = (self.candidateCapturedImage.frame.size.width)/2
//            self.candidateCapturedImage.clipsToBounds = true
        } else {
            self.candidateCapturedImage.isHidden = true
            self.noImagesData.isHidden = false
        }
        
        self.navigationItem.title = candidateName + "ID"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
