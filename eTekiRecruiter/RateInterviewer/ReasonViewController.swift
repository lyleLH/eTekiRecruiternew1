//
//  ReasonViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 14/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class ReasonViewController: BaseViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cancelledByHeader: UILabel!
    @IBOutlet weak var cancelledByLabel: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var cancelledAtHeader: UILabel!
    @IBOutlet weak var cancelledAtLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reason: UILabel!
    var interviewerID = String()
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    override func viewDidLoad() {
        super.viewDidLoad()
          view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
          view.isOpaque = true
          reasonTextView.isEditable = false
          reasonTextView.layer.borderWidth = 1
          reasonTextView.layer.cornerRadius = 5
          reasonTextView.layer.borderColor = AppTheme.containerBorderColor.cgColor
          reasonTextView.textColor = AppTheme.textColor
        reasonTextView.font =  UIFont(name: APPFonts.lightFont, size: 16.0)
        headerLabel.bold(size: 18)
        cancelledAtHeader.bold(size: 14)
        cancelledByHeader.bold(size: 14)
        reason.bold(size: 14)
        cancelledByLabel.light(size: 16)
        cancelledAtLabel.light(size: 16)
        cancelButton.bold(size: 18)
          getCancellationDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopupAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getCancellationDetails(){
        let manger = CandidatesManager(interviewID: self.interviewerID)
        self.showSpinner()
        self.candidatesAPI.getCancellationReason(candidateManger: manger)  {(response , error) in
            if(response != nil) {
               let success = response?["success"] as? Bool ?? false
                if(success){
                    DispatchQueue.main.async {
                        if let details = response?["cancellation_details"] as? Dictionary<String, Any>{
                            if let cancelledBy = details["cancelled_by"] as? String{
                                self.cancelledByLabel.text = cancelledBy
                            }
                            if let cancelledAt = details["cancelled_at"] as? String{
                                let date = self.convertUTCToLocalTime(date: cancelledAt)
                                self.cancelledAtLabel.text = "\(date)"
                            }
                            if let reason = details["reason"] as? String{
                                self.reasonTextView.text = reason
                            }
                        }
                        self.removeSpinner()
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
    
    func convertUTCToLocalTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            if let result = UserDefaults.standard.value(forKey: "RecruiterTimeZone") as? Dictionary<String, String> {
                dateFormatter.timeZone = TimeZone(identifier: result.keys.first ?? "")
            }
            dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
            return dateFormatter.string(from: dt)
        } else {
            return "Unknown date"
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

