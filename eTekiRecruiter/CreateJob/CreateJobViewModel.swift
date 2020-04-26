//
//  CreateJobViewModel.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 25/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import Foundation
import FlexibleSteppedProgressBar

struct CreateJobViewModel  {
    
    var dateTextField = UITextField()
    var steppedProgressBar =  FlexibleSteppedProgressBar()

    var createJobRespone = CreateJobResponse()
    
    func updatedSteppedBar() {
        steppedProgressBar.numberOfPoints = 3
        steppedProgressBar.lineHeight = 4
        steppedProgressBar.radius = 17
        steppedProgressBar.progressRadius = 17
        steppedProgressBar.progressLineHeight = 4
        steppedProgressBar.currentIndex = 0
        steppedProgressBar.displayStepText = false
        steppedProgressBar.selectedOuterCircleLineWidth = 0
        steppedProgressBar.backgroundShapeColor = CreateJobFonts.selectedOuterCircleStrokeColor
        steppedProgressBar.selectedBackgoundColor = CreateJobFonts.selectedBackgoundColor
        steppedProgressBar.currentSelectedCenterColor = CreateJobFonts.currentSelectedCenterColor
        steppedProgressBar.selectedOuterCircleStrokeColor = CreateJobFonts.selectedBackgoundColor
        steppedProgressBar.stepTextColor = CreateJobFonts.stepTextColor
        steppedProgressBar.currentSelectedTextColor = CreateJobFonts.currentSelectedCenterColor
        steppedProgressBar.viewBackgroundColor = AppTheme.appBackgroundColor
        steppedProgressBar.stepTextFont = UIFont.appLightFontWith(size: 14.0)
    }


    
}

