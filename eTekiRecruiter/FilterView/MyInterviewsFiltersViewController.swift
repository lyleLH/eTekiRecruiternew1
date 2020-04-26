//
//  MyInterviewsFiltersViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 26/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import  SimpleCheckbox

struct interviewsData {
    var opened = Bool()
    var title = String()
    var sectionData = [[String : Any]]()
}

class MyInterviewsFiltersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segmentIndex = 0
    var selectedfilterArray = [String]()
    var selecteddueDate = ""
    var openedSections = [IndexPath]()
    var tableViewData = [interviewsData]()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var filterArray = [] as Array<Dictionary<String,Any>>
    var interviewData = [Any]()
    @IBOutlet weak var myInterviewsFilterTableView: UITableView!
    @IBOutlet weak var dateTextField: PaddingTextField!
    var status = true
     var path = IndexPath()
    
    var inProgressStatus = false
    var scheduledStatus = false
    var pendingReport = false
    var pendingApproval = false
    var completed = false
    var priorHour = false
    var pendingResubmission = false
    var lateCancellation = false
    var candidatePending = false
    var candidateConfirmed = false
    var interViewerPending = false
    var interviewerConfirmed = false
    var waitingOnCandidate = false
    var waitingOnInterviewer = false
    var pendingPayment = false
    var myInterviews = false
    var contributorInterviews = false
    var val = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.selectedfilterArray)
        setUpFilters(value: true)
        
        
        
        tableViewData = [interviewsData(opened: false, title: "Interview", sectionData: [["name": MyinterviewsStatus.scheduled, "status": scheduledStatus], ["name": MyinterviewsStatus.inProgress, "status": inProgressStatus]]),
                         interviewsData(opened: false, title: "Report", sectionData: [["name": MyinterviewsStatus.pendingReport, "status": pendingReport], ["name": MyinterviewsStatus.pendingApproval, "status": pendingApproval], ["name": MyinterviewsStatus.pendingResubmission, "status": pendingResubmission], ["name": MyinterviewsStatus.completed, "status": completed]]),
                         interviewsData(opened: false, title: "Cancelled", sectionData: [["name": MyinterviewsStatus.priorHour, "status": priorHour], ["name": MyinterviewsStatus.lateCancellation, "status": lateCancellation]]),
                         interviewsData(opened: false, title: "No Show", sectionData: [["name": MyinterviewsStatus.candidatePending, "status": candidatePending], ["name": MyinterviewsStatus.candidateConfirmed, "status": candidateConfirmed], ["name": MyinterviewsStatus.interViewerPending, "status": interViewerPending], ["name": MyinterviewsStatus.interviewerConfirmed, "status": interviewerConfirmed]]),
                         interviewsData(opened: false, title: "Scheduling", sectionData: [["name": MyinterviewsStatus.waitingOnCandidate, "status": waitingOnCandidate], ["name": MyinterviewsStatus.waitingOnInterviewer, "status": waitingOnInterviewer]]),
                         interviewsData(opened: true, title: "", sectionData: [["name": MyinterviewsStatus.pendingPayment, "status": pendingPayment], ["name": MyinterviewsStatus.myInterviews, "status": myInterviews], ["name": MyinterviewsStatus.contributorInterviews, "status": contributorInterviews]]),]
        // Do any additional setup after loading the view.
    }
    
    func setUpFilters(value: Bool) {
        for filter in self.selectedfilterArray {
            
            switch filter {
                case MyinterviewsStatus.inProgress:
                    inProgressStatus = value
                    
                case MyinterviewsStatus.scheduled:
                     scheduledStatus = value
                    
                case MyinterviewsStatus.pendingReport:
                    pendingReport = value
                    
                case MyinterviewsStatus.pendingApproval:
                      pendingApproval = value
                    
                case MyinterviewsStatus.completed:
                     completed = value
                    
                case MyinterviewsStatus.priorHour:
                     priorHour = value
                    
                case MyinterviewsStatus.pendingResubmission:
                    pendingResubmission = value

                case MyinterviewsStatus.lateCancellation:
                    lateCancellation = value
                    
                case MyinterviewsStatus.candidatePending:
                    candidatePending = value
                    
                case MyinterviewsStatus.candidateConfirmed:
                    candidateConfirmed = value
                    
                case MyinterviewsStatus.interViewerPending:
                    interViewerPending = value
                    
                case MyinterviewsStatus.interviewerConfirmed:
                    interviewerConfirmed = value
                    
                case MyinterviewsStatus.waitingOnCandidate:
                    waitingOnCandidate = value
                
                case MyinterviewsStatus.waitingOnInterviewer:
                    waitingOnInterviewer = value
                    
                case MyinterviewsStatus.pendingPayment:
                    pendingPayment = value
                    
                case MyinterviewsStatus.myInterviews:
                    myInterviews = value
                    
                case MyinterviewsStatus.contributorInterviews:
                    contributorInterviews = value
                default:
                    print("Default Step")
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableViewData[section].opened == true) {
            if(section != tableViewData.count-1) {
               return tableViewData[section].sectionData.count+1
            } else {
                return tableViewData[section].sectionData.count
            }
        } else {
            return 1
        }
    }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyInterviewsFilterTableViewCell()


        var row = indexPath.row-1
        if(indexPath.section == tableViewData.count-1) {
            row = indexPath.row
        }
        if(indexPath.row == 0 && indexPath.section != tableViewData.count-1) {
            if(indexPath.section != tableViewData.count) {
                cell = myInterviewsFilterTableView.dequeueReusableCell(withIdentifier: "sectionCell") as! MyInterviewsFilterTableViewCell
                cell.headerLabel.bold(size: 16.0)
                cell.headerLabel.text = tableViewData[indexPath.section].title
                if tableViewData[indexPath.section].opened {
                    cell.dropdownImageButton.imageView?.image = UIImage(named: "downArrow")
                    cell.headerBoderLabel.isHidden = true
                } else {
                    cell.dropdownImageButton.imageView?.image = UIImage(named: "dropdownarrow")
                    cell.headerBoderLabel.isHidden = false
                }
            }
          }else {
            cell = myInterviewsFilterTableView.dequeueReusableCell(withIdentifier: "dataCell") as! MyInterviewsFilterTableViewCell
            cell.dataLabel.light(size: 18.0)
            cell.filterCheckBox.isChecked = tableViewData[indexPath.section].sectionData[row]["status"] as? Bool ?? false
            cell.filterCheckBox.tag = (indexPath.section*100)+indexPath.row
            cell.dataLabel.text = tableViewData[indexPath.section].sectionData[row]["name"] as? String
            setUpCheckbox(cell: cell)
            if(tableViewData[indexPath.section].sectionData.count == indexPath.row) {
                cell.borderLabel.isHidden = false
            } else {
                cell.borderLabel.isHidden = true
            }
          }
         return cell
      }
    
    func setUpCheckbox(cell: MyInterviewsFilterTableViewCell) {
          cell.filterCheckBox.borderLineWidth = 1
          cell.filterCheckBox.checkmarkStyle = .tick
          cell.filterCheckBox.checkmarkColor = AppTheme.textColor
          cell.filterCheckBox.uncheckedBorderColor = AppTheme.fieldsBorderColor
          cell.filterCheckBox.checkedBorderColor = AppTheme.fieldsBorderColor
    }
    
    @IBAction func checkBoxActions(_ sender: Checkbox) {
        let section = sender.tag / 100
        var row = sender.tag % 100
        if(section != tableViewData.count-1) {
            row = row-1
        }
        tableViewData[section].sectionData[row]["status"] = !(tableViewData[section].sectionData[row]["status"] as? Bool ?? false)
        myInterviewsFilterTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0 && indexPath.section != tableViewData.count-1) {
            if(tableViewData[indexPath.section].opened == true) {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
//    @IBAction func dateButtonAction(_ sender: Any) {
//        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        datePicker.datePickerMode = .date
//        var components = DateComponents()
//        components.year = -5
//        datePicker.minimumDate = Calendar.current.date(byAdding: components, to: Date())
//        components.year = 5
//        datePicker.maximumDate = Calendar.current.date(byAdding: components, to: Date())
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//          dateTextField.inputAccessoryView = toolbar
//          dateTextField.inputView = datePicker
//          self.dateTextField.becomeFirstResponder()
//    }
//    
//    @objc func donedatePicker() {
//        dateTextField.text = dateFormatter.string(from: datePicker.date)
//        self.view.endEditing(true)
//    }
//    
//    @objc func cancelDatePicker() {
//        self.view.endEditing(true)
//    }
    
    @IBAction func applyAction(_ sender: Any) {
        clearStatus()
    }
    
    func clearStatus() {
        if(selectedfilterArray.count != 0) {
            selectedfilterArray.removeAll()
        }
        for i in 0..<tableViewData.count{
            for j in 0..<tableViewData[i].sectionData.count {
                   selectedfilterArray.append(tableViewData[i].sectionData[j]["name"] as? String ?? "")
                   tableViewData[i].sectionData[j]["status"] = false
            }
        }
        setUpFilters(value: false)
        myInterviewsFilterTableView.reloadData()
    }
    
    func getFiltersArray() {
        if filterArray.count > 0 {
            filterArray.removeAll()
        }
        var filter1 = Dictionary<String,Any>()
        var statusFilters = Array<Dictionary<String,Any>>()
        for i in 0..<tableViewData.count{
            var arrayData = [String]()
            for j in 0..<tableViewData[i].sectionData.count {
                if(tableViewData[i].sectionData[j]["status"] as? Bool ?? false) {
                    let selectedFilter = tableViewData[i].sectionData[j]["name"] as? String ?? ""
                     if selectedFilter == MyinterviewsStatus.pendingPayment {
                        statusFilters.append(["payment" :[selectedFilter]])
                    } else {
                        if(selectedFilter == MyinterviewsStatus.contributorInterviews) {
                             arrayData.append("My Collaboration")
                        } else {
                             arrayData.append(selectedFilter)
                        }
                    }
                }
            }
            if !arrayData.isEmpty {
                if(tableViewData[i].title == "") {
                     filter1 = ["interview_type" : arrayData]
                    filterArray.append(filter1)
                } else {
                    if(tableViewData[i].title == MyinterviewsStatus.noShow) {
                      filter1 = ["no_show" : arrayData]
                    } else {
                        filter1 = [tableViewData[i].title.lowercased() : arrayData]
                    }
                    statusFilters.append(filter1)
                }
            }
         }
        filterArray.append(["status_filters": statusFilters])
        print(filterArray)
        self.handleFiltersNotifications()
    }
    
    @IBAction func saveFiltersAction(_ sender: Any) {
        getFiltersArray()
    }
    
    func handleFiltersNotifications() {
        NotificationCenter.default.post(name: Notification.Name("updateInterviewFilters"), object: nil, userInfo: ["interviewFilters":filterArray, "interviewData": self.interviewData])
        self.dismiss(animated: false, completion: nil)
    }
    
}
