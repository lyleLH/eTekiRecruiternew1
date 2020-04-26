//
//  DashBoardViewModel.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 23/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

struct DashBoardViewModel {
    var segmentContoller = UISegmentedControl()
    var searchBy = UITextField()
    var searchView = UIView()
    var dashboardTableView = UITableView()

    var filterButton = UIButton()
    var createJob = UIButton()

    func updateSegementController() {

        if #available(iOS 13.0, *) {
            /// segmentContoller.selectedSegmentTintColor = AppTheme.brandColor

            segmentContoller.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
            segmentContoller.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : DashBoardScreenFonts.segementTitleColor], for: .disabled)
            self.segmentContoller.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.appRomanFontWith(size: 18.0)], for: .normal)
            segmentContoller.layer.borderWidth = 1.0
            segmentContoller.layer.borderColor = AppTheme.brandColor.cgColor
            segmentContoller.layer.shadowColor = AppTheme.shadowColor.cgColor
            let clearImage = UIImage.imageWithColor(color: UIColor.white)
            let selectedImage = UIImage.imageWithColor(color: AppTheme.brandColor)
            segmentContoller.setDividerImage(selectedImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            segmentContoller.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
            segmentContoller.setBackgroundImage(selectedImage, for: .selected, barMetrics: .default)
            
            segmentContoller.layer.borderColor = AppTheme.brandColor.cgColor
            segmentContoller.clipsToBounds = true
            
            
        } else {
            let fontAttribute = [NSAttributedString.Key.font: UIFont.appRomanFontWith(size: 18.0),
                                 NSAttributedString.Key.foregroundColor: DashBoardScreenFonts.segementTitleColor]
            segmentContoller.setTitleTextAttributes(fontAttribute as [NSAttributedString.Key : Any], for: .normal)
            segmentContoller.layer.borderColor = AppTheme.brandColor.cgColor
        }
        segmentContoller.selectedSegmentIndex = 0
    }
    
    func setUpView() {
        self.updateSegementController()
        self.dashboardTableView.isHidden = true
        self.searchView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.searchView.clipsToBounds = true
        self.searchView.layer.borderWidth = 1
        self.searchView.layer.cornerRadius = 5
    }
    
    func setUpCreateJob() {
        if segmentContoller.selectedSegmentIndex == 0 {
            createJob.isHidden = false
        } else {
            createJob.isHidden = true
        }
    }
    
}
