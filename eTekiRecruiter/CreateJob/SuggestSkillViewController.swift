//
//  SuggestSkillViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import DLRadioButton

class SuggestSkillViewController: BaseViewController {
    
    @IBOutlet weak var requiredButton: DLRadioButton!
    @IBOutlet weak var optionalButton: DLRadioButton!
    @IBOutlet weak var suggestSkillTextField: UITextField!
    @IBOutlet weak var requiredSkillLabel: UILabel!
    @IBOutlet weak var optionalSkillLabel: UILabel!
    @IBOutlet weak var suggestButton: UIButton!
    
    var searchSuggestSkills = [String]()
    var createJobAPI: CreateJobAPIProtocol.Type = CreateJobAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        suggestSkillTextField.light(size: 18)
        requiredSkillLabel.bold(size: 16)
        optionalSkillLabel.bold(size: 16)
        suggestButton.bold(size: 18)
    }
    
    @IBAction func selectRequiredction(_ sender: Any) {
        self.optionalButton.isSelected = false
    }
    
    @IBAction func selectOptionalction(_ sender: Any) {
        self.requiredButton.isSelected = false
    }
    
    @IBAction func suggestSkillAction(_ sender: Any) {
        
        if self.suggestSkillTextField.text != "" {
            
            if !requiredButton.isSelected && !optionalButton.isSelected {
                self.showBanner(title: "", withMessage: .skillBlankMessage, style: .warning)
            } else {
                
                self.showSpinner()
                self.createJobAPI.getSkillsAutoComplete(createJobManager: CreateJobManager(skillsAutoCompleteText: self.suggestSkillTextField.text ?? "")) { (response, errorResponse) in
                    
                    if errorResponse != nil {
                        guard let message = errorResponse?.message else {return}
                        self.handleErrorResponse(message: message)
                        
                    } else {
                        DispatchQueue.main.async {
                            self.searchSuggestSkills = response?.autoSkills ?? [String]()
                            self.filterSuggestSkills()
                        }
                    }
                }
            }
        } else {
            self.showBanner(title: "", withMessage: .skillBlankMessage, style: .warning)
            self.suggestSkillTextField.becomeFirstResponder()
        }
    }
    
    func filterSuggestSkills() {
        
        let skillExistInDataBase = self.searchSuggestSkills.contains(obj: self.suggestSkillTextField.text)
        if skillExistInDataBase {
            self.removeSpinner()
            self.showBanner(title: "", withMessage: "SKILL_TYPE_ALREADY_EXIST_MESSAGE".localized, style: .warning)
        } else {
            
            if !requiredButton.isSelected && !optionalButton.isSelected {
                self.showBanner(title: "", withMessage: .skillBlankMessage, style: .warning)
            } else {
                var skillType = ""
                
                if requiredButton.isSelected {
                    skillType = "required"
                } else {
                    skillType = "optional"
                }
                
                
                self.createJobAPI.suggestSkill(createJobManager: CreateJobManager(skill: self.suggestSkillTextField.text ?? "", skillType: skillType)) { (response, errorResponse) in
                    if errorResponse != nil {
                        guard let message = errorResponse?.message else {return}
                        self.handleErrorResponse(message: message)
                    } else {
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            self.suggestSkillTextField.text = ""
                            self.requiredButton.isSelected = false
                            self.optionalButton.isSelected = false
                            self.showBanner(title: "", withMessage: response?.message ?? "Suggestion Updated.", style: .success)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
