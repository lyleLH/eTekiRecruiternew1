//
//  AddCommentViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 13/03/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class AddCommentViewController: BaseViewController, UITextViewDelegate {

    var isNavigatingFrom = ""
    var interviewReportId = ""
    var status = false
    var report_status = ""
    
    @IBOutlet weak var revertCheckBox: Checkbox!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
        view.isOpaque = true
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 3
        commentTextView.layer.borderColor = AppTheme.containerBorderColor.cgColor
        commentTextView.text = "Comment"
        //titleLabel.roman(size: 18)
        commentTextView.light(size: 18)
        cancelButton.bold(size: 18)
        submitButton.bold(size: 18)
        commentTextView.contentInset = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        commentTextView.delegate = self
        commentTextView.textColor = AppTheme.placeHolderColor
        hideSubmitButton(status: false)
        revertCheckBox.borderLineWidth = 1
        revertCheckBox.checkmarkStyle = .tick
        revertCheckBox.checkmarkColor = AppTheme.textColor
        revertCheckBox.uncheckedBorderColor = AppTheme.fieldsBorderColor
        revertCheckBox.checkedBorderColor = AppTheme.fieldsBorderColor
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
       self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
      if(self.commentTextView.text == "Comment" || self.commentTextView.text.trimSpace(str: self.commentTextView.text) == "") {
              self.showBanner(title: "", withMessage: "Comment can't be blank" , style: .warning)
      } else if (self.revertCheckBox.isChecked == true && (report_status == RevertReport.requestEditsAdmin  || report_status == RevertReport.requestEditsRecruiter || report_status == RevertReport.pendingAdminApproval )) {
            self.view.isHidden = true
            self.performSegue(withIdentifier: "revertToCustomPopup", sender: nil)
        } else {
             self.showSpinner()
        let manager = CandidatesManager(interviewReportId: self.interviewReportId, content: self.commentTextView.text, revertStatus: self.revertCheckBox.isChecked)
        candidatesAPI.revertReport(candidateManger: manager){(response , error) in
         if(response != nil) {
           let success = response?["success"] as? Bool ?? false
            if(success){
                let successMessage = response?["message"] as? [String] ?? ["Success"]
                DispatchQueue.main.async {
                    self.showBanner(title: "", withMessage: successMessage[0] , style: .success)
                     
                      NotificationCenter.default.post(name: Notification.Name("reloadComments"), object: nil, userInfo: nil)
                        self.removeSpinner()
                        self.dismiss(animated: false, completion: nil)
                  }
                    
            }else {
               DispatchQueue.main.async {
                  self.removeSpinner()
                  self.showBanner(title: "", withMessage: error?.message ?? "Server error", style: .danger)
               }
            }
         }else {
            guard let message = error?.message else {return}
            self.handleErrorResponse(message: message)
        }
        }
        }
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "revertToCustomPopup" {
            if let navVc = segue.destination as? NoshowReasonViewController {
                navVc.isNavigatingFrom = RevertReport.revert
                navVc.report_status = self.report_status as? String ?? ""
            }
        }
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
extension AddCommentViewController {
   func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView.textColor == AppTheme.placeHolderColor {
            textView.text = ""
            textView.textColor = AppTheme.textColor
        }
    
   }

   func textViewDidChange(_ textView: UITextView) {
       if( textView.text == "Comment" || textView.text.trimSpace(str: textView.text) == ""){
          hideSubmitButton(status: false)
       } else {
          hideSubmitButton(status: true)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
                textView.text = "Comment"
            textView.textColor = AppTheme.placeHolderColor
        }
     }

    func hideSubmitButton(status: Bool) {
        self.submitButton.isEnabled = status
        if status {
          self.submitButton.alpha = 1.0
        } else {
           self.submitButton.alpha = 0.5
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
