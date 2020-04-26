//
//  ProfileViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 10/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
import SideMenu
@testable import eTekiRecruiter

class ProfileViewControllerTests: XCTestCase {
    
    var profileViewController: ProfileViewController!
    var profileNavigationController: UINavigationController!
    var cell : ProfileCollectionViewCell! = nil
    
    override func setUp() {
        profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        profileNavigationController = UINavigationController(rootViewController: profileViewController)

        profileViewController.view.layoutIfNeeded()
        profileNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = profileNavigationController
        cell = profileViewController.profileCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProfileCollectionViewCell
        
    }
    
    override func tearDown() {
        profileViewController = nil
        profileNavigationController = nil
        cell = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testProfileDidSelectItemAt(){
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 1, section: 0))
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 2, section: 0))
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 3, section: 0))
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 4, section: 0))
        profileViewController.collectionView(profileViewController.profileCollectionView, didSelectItemAt: IndexPath(row: 5, section: 0))
    }
    func testProfileCollection() {
        profileViewController.profileCollectionView.reloadData()
        
        
        let profileList = [["Primary Info": "primary_icon"], ["Address": "address_icon"], ["Change Password": "key"], ["Company": "company"], ["SMS Settings": "mail_icon"], ["Generate Passcode": "barcode"]]
        
        XCTAssertEqual(profileList , profileViewController.profileData,"Data mismatch")
        
        for index in 0..<profileList.count {
            cell = profileViewController.profileCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ProfileCollectionViewCell
            
            let profileDict = profileList[index]

            for (key,value) in profileDict {
                
//                print(cell.profileLabel.text)
//                XCTAssertEqual(cell.profileLabel?.text, key,"Profile Cell Data Mismatch")
//                XCTAssertEqual(cell.iconImageView?.image, UIImage(named: value),"Profile Cell Data Mismatch")
            }
           // XCTAssertEqual(stubArray[index], cell.profileLabel.text,"filter view table view data mismatch mismatch")
        }
        
        
    }

}
