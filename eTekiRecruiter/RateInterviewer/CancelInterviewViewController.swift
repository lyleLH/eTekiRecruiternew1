//
//  CancelInterviewViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 17/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class CancelInterviewViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var optionsTableView: UITableView!
    var count = 5
    var interviewID = ""
    var infoData = [String: Any]()
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var startTimeWithJobTitle: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    var status = false
    var isNavigatingFrom = ""
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var data = [["name": "Candidate Unavailable", "isChecked": false],["name": "Candidate took another offer", "isChecked": false] , ["name": "Job closed without filling", "isChecked": false], ["name": "Job On-Hold", "isChecked": false], ["name": "Other", "isChecked": false]]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        print(infoData)
        self.optionsTableView.layer.borderWidth = 1
        self.optionsTableView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.optionsTableView.layer.cornerRadius = 5
        if let title = infoData["title"] as? String{
            if let time = infoData["startTime"] as? String{
                startTimeWithJobTitle.text = title + " on " + time
            }
        }
        setUpNavigationBar()
        noteLabel.light(size: 18)
        startTimeWithJobTitle.bold(size: 16)
        yesButton.bold(size: 18)
        noButton.bold(size: 18)
//       view.isOpaque = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if(indexPath.row == 5){
             let cell = optionsTableView.dequeueReusableCell(withIdentifier: "commentTextView") as? CancelInterviewCell
            if(status == false){
                cell?.commentTextView.text = "Enter Comments"
            }
              let comment  = cell?.commentTextView.text
            if(comment?.trimSpace(str: comment ?? "") == "" || comment == "Enter Comments"){
                   self.yesButton.isEnabled = false
                   self.yesButton.alpha = 0.5
                cell?.commentTextView.textColor = AppTheme.placeHolderColor
              } else {
                   self.yesButton.isEnabled = true
                   self.yesButton.alpha = 1.0
                cell?.commentTextView.textColor = AppTheme.textColor
              }
            cell?.commentTextView.light(size: 16)
            cell?.commentTextView.delegate = self
             return cell ?? UITableViewCell()
        } else {
            let cell = optionsTableView.dequeueReusableCell(withIdentifier: "optionsList") as? CancelInterviewCell
            if(indexPath.row == 4){
                cell?.optionTitleLabel.text = data[indexPath.row]["name"] as? String
                cell?.dropdownView.isHidden = false
                if(count != 6){
                    cell?.dropdownImage.image = UIImage(named: "dropdownarrow")
                } else {
                    if(status == false){
                      optionsTableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .none, animated: true)
                    }
                     cell?.dropdownImage.image = UIImage(named: "downArrow")
                }
                cell?.checkBox.isHidden = true
            }else {
                cell?.optionTitleLabel.text = data[indexPath.row]["name"] as? String
                cell?.checkBox.borderLineWidth = 1
                cell?.dropdownView.isHidden = true
                cell?.checkBox.checkmarkStyle = .tick
                cell?.checkBox.tag = indexPath.row
                cell?.checkBox.isChecked = data[indexPath.row]["isChecked"] as? Bool ?? false
                cell?.checkBox.checkmarkColor = AppTheme.textColor
                cell?.checkBox.uncheckedBorderColor = AppTheme.fieldsBorderColor
                cell?.checkBox.checkedBorderColor = AppTheme.fieldsBorderColor
            }
            cell?.optionTitleLabel.light(size: 18)
            return cell ?? UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 4){
         if(count != 6){
            self.count = 6
            status = false
         } else {
            self.count = 5
            status = true
            self.yesButton.isEnabled = true
            self.yesButton.alpha = 1.0
         }
        } else {
          if(count != 6){
            self.count = 5
            self.yesButton.isEnabled = true
           self.yesButton.alpha = 1.0
          } else {
            self.count = 6
          }
            status = true
        }
        optionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 5){
            return 93
        } else {
            return 43
        }
    }
    
    @IBAction func checkboxSelected(_ sender: Checkbox) {
        self.data[sender.tag]["isChecked"] = sender.isChecked
        optionsTableView.reloadData()
    }
    
    
    @IBAction func noAction(_ sender: Any) {
        if(isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview){
           self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        } else {
          self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func yesAction(_ sender: Any) {
        validations()
    }
    
    func validations() {
        var options = ""
        for index in 0..<data.count {
            if (index != 4) {
                if(data[index]["isChecked"] as? Bool ?? false){
                    options += ", " + (data[index]["name"] as? String ?? "")
                }
            }
        }
        if count == 6 {
            let cell = optionsTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
            let comment = cell?.commentTextView.text
            if(comment?.trimSpace(str: comment ?? "") != "" || comment != "Enter Comments"){
                options += ", " + (comment ?? "")
            }
        }
        if(options == "") {
            self.showBanner(title: "", withMessage: "Select atleast one reason", style: .warning)
        } else {
            options.remove(at: options.startIndex)
            options.remove(at: options.startIndex)
            cancelInterviewReason(reason: options)
        }
    }
    
    func cancelInterviewReason(reason: String) {
        print(interviewID)
        let manager = CandidatesManager(interviewID: self.interviewID, cancellationReason: reason)
        self.showSpinner()
        candidatesAPI.cancelInterviewReason(candidateManger: manager) {(response , error) in
            if(response != nil) {
               let success = response?["success"] as? Bool ?? false
                if(success) {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        let successMessage = response?["message"] as? [String] ?? ["Success"]
                        self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                        self.view.isHidden = true
                        let info = response?["interview"] as? [String:Any]
                        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.cancelInterviewToConfirmation, sender: info)
                    }
                } else {
                   DispatchQueue.main.async {
                      self.removeSpinner()
                      self.showBanner(title: "", withMessage: error?.message ?? "Server error", style: .danger)
                   }
                }
             } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.cancelInterviewToConfirmation {
            if let navVc = segue.destination as? CancellationConfirmedViewController {
                navVc.infoData = sender as? [String : Any] ?? [:]
                navVc.isNavigatingFrom = self.isNavigatingFrom
            }
        }
    }
}

extension CancelInterviewViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
               if textView.textColor == AppTheme.placeHolderColor {
                   textView.text = ""
                   textView.textColor = AppTheme.textColor
               }
       }

    func textViewDidChange(_ textView: UITextView) {
        if(textView.text == "Enter Comments" || textView.text.trimSpace(str: textView.text) == "") {
            self.yesButton.isEnabled = false
            self.yesButton.alpha = 0.5
            status = false
        } else {
            self.yesButton.isEnabled = true
            self.yesButton.alpha = 1.0
            status = true
        }
    }
       func textViewDidEndEditing(_ textView: UITextView) {
               if textView.text.isEmpty {
                   textView.text = "Enter Comments"
                   textView.textColor = AppTheme.placeHolderColor
               }
       }
       
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }
}
