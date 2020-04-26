//
//  PrimaryTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 09/03/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import GrowingTextView

protocol PrimaryTableCellDelegate {
    func updateValue(response : CreateJobResponse?)
}

class PrimaryTableViewCell: BaseViewCell {

    var delegate : PrimaryTableCellDelegate?


    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var jobRequistionNumber: UITextField!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var hiringCompanyLogo: UITextField!
    @IBOutlet weak var uploadLogo: UIButton!
    @IBOutlet weak var hiringCompanyName: UITextField!
    @IBOutlet weak var yearsOfExperience: UITextField!
    @IBOutlet weak var jobDueDate: UITextField!
    @IBOutlet weak var numberOfCandidates: UITextField!
    @IBOutlet weak var jobDescUploadButton: UIButton!
    @IBOutlet weak var areasOfExpertise: UITextField!
    @IBOutlet weak var areaOfExpertiseButton: UIButton!

    @IBOutlet weak var jobDescriptionTextView: GrowingTextView!

   // @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var jobDescriptionUploadFile: UITextField!

    let datePicker  = UIDatePicker()
    var viewModel = CreateJobViewModel()

    var createJobResponse = CreateJobResponse()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.jobRequistionNumber?.keyboardType = .numberPad
        self.numberOfCandidates?.keyboardType = .numberPad


        self.setUpToolBar()
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/*
extension PrimaryTableViewCell : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView == self.jobDescriptionTextView {
            if textView.textColor == AppTheme.placeHolderColor {
                textView.text = ""
                textView.textColor = AppTheme.textColor
            }
            textView.isScrollEnabled = true
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.jobDescriptionTextView {
            if textView.text.isEmpty {
                textView.text = "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized
                textView.textColor = AppTheme.placeHolderColor
            }
            adjustUITextViewHeight(arg: textView)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }


} */

extension PrimaryTableViewCell : UITextFieldDelegate {

    func adjustUITextViewHeight(arg : UITextView)
      {
          arg.translatesAutoresizingMaskIntoConstraints = true
          arg.sizeToFit()
          arg.isScrollEnabled = false
         // primaryTableView.reloadRows(at: [IndexPath(row: 8, section: 0)], with: .none)
      }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        if textField == yearsOfExperience  || textField == numberOfCandidates {
            let cs = CharacterSet(charactersIn: TextFieldConstants.ACCEPTABLECHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension PrimaryTableViewCell {

    func setUpToolBar() {
        let customToolBar = UIView()
        customToolBar.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width,
                                     height: 50)

        let doneButton = UIButton(frame: CGRect(x: 8, y: 0, width: 50, height: 50))
        doneButton.addTarget(self, action: #selector(donedatePicker), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.light(size: 18.0)
        customToolBar.addSubview(doneButton)


        let cancelButton = UIButton(frame: CGRect(x: ScreenSize.width-68, y: 0, width: 60, height: 50))
        cancelButton.addTarget(self, action: #selector(cancelDatePicker), for: .touchUpInside)
        cancelButton.light(size: 18.0)
        cancelButton.setTitle("Cancel", for: .normal)
        customToolBar.addSubview(cancelButton)

        customToolBar.backgroundColor = AppTheme.brandColor
        customToolBar.sizeToFit()
        self.jobDueDate?.inputAccessoryView = customToolBar
    }


    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = Formats.date_monthFormat
        if(formatter.string(from: datePicker.date) == formatter.string(from: Date())) {
            self.showBanner(title: "", withMessage: .jobDateCantTodaysDate, style: .warning)
            self.jobDueDate?.text = ""
        }else {
            self.jobDueDate?.text = formatter.string(from: datePicker.date)
        }
        createJobResponse.dueDate = self.jobDueDate.text ?? ""
        self.delegate?.updateValue(response: createJobResponse)
        self.jobDueDate?.resignFirstResponder()
    }

    @objc func cancelDatePicker() {
        print("Cancel Called")
        self.jobDueDate?.resignFirstResponder()
    }

    @IBAction func showDatePicker(_ sender : UIButton) {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        self.jobDueDate?.inputView = datePicker
        self.jobDueDate?.becomeFirstResponder()
    }

}
