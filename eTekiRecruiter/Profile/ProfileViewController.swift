//
//  ProfileViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 15/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var profileData : [[String : String]] = [[.primaryInfo : Assets.primaryIcon],[.address : Assets.addressIcon],[.changePassword : Assets.keyIcon],[.company : Assets.companyIcon],[.smsSettings : Assets.mailIcon],[.generatePassCode : Assets.barcodeIcon]] 


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItems(self.menuItem, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarColor(color: AppTheme.statusBarDefaultColor)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.profileCollectionViewCell, for: indexPath) as! ProfileCollectionViewCell
        
        let profileDict = profileData[indexPath.row]
        
        cell.profileContentView.layer.borderWidth = 1
        cell.profileContentView.layer.borderColor =  AppTheme.containerBorderColor.cgColor
        cell.profileContentView.layer.cornerRadius = 3

        cell.profileLabel.light(size: 18.0)
        cell.profileLabel.textColor = AppTheme.textColor

        for (key,value) in profileDict {
            cell.profileLabel.text = key
            cell.iconImageView.image = UIImage(named: value)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth : CGFloat = (collectionView.frame.size.width - 24) / 2.0
        let cellSize = CGSize(width: cellWidth , height:cellWidth)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            self.performSegue(withIdentifier: "ProfileToPrimaryInfo", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "ProfileToAddress", sender: self)
            break
        case 2:
            self.performSegue(withIdentifier: "ProfileToChangePassword", sender: self)
            break
        case 3:
            self.performSegue(withIdentifier: "ProfileToCompany", sender: self)            
            break
        case 4:
            self.performSegue(withIdentifier: "ProfileToSMSSetttings", sender: self)
            break
        case 5:
            generateEventLogToAnalytics(eventName: "Generate Passcode Event", status: "True")
            self.performSegue(withIdentifier: "ProfileToGeneratePasscode", sender: self)
            break
        default:
            break
        }
        
    }


}
