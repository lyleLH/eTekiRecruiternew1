//
//  DatePcikerViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 14/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

protocol callBackDelegate {
    func callBackToParent()
}
class DatePcikerViewController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reactivateButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var jobId : String = ""
    var selectedDate: String = ""
    var delegate : callBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
        view.isOpaque = true
        headerLabel.bold(size: 18)
        reactivateButton.bold(size: 18)
        cancelButton.bold(size: 18)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    

    @IBAction func reactivateJobAction(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if(formatter.string(from: datePicker.date) == formatter.string(from: Date())){
            self.showBanner(title: "" , withMessage: "Job due date expired", style: .warning)
        }else {
            print(formatter.string(from: datePicker.date))

           self.showSpinner()
           JobListingAPI.reactivateJob(jobDetails: JobsManager(jobID: jobId, due_at: "\(formatter.string(from: datePicker.date))")) { (response, error) in
                if response != nil {
                        let res = response?.message ?? "Job Reactivated."
                        DispatchQueue.main.async {
                            self.delegate?.callBackToParent()
                            self.dismiss(animated: false, completion: nil)
                            self.removeSpinner()
                            self.showBanner(title: "", withMessage: res, style: .success)
                        }
               } else {
                    DispatchQueue.main.async{
                      self.dismiss(animated: false, completion: nil)
                      self.removeSpinner()
                        self.showBanner(title: "" , withMessage: error?.message ?? "Server Error", style: .danger)
                    }
               }
           }
        }
    }
    

}

