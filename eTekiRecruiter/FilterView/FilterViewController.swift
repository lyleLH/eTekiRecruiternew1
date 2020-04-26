//
//  FilterViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 17/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import DropDown

enum DueDate : String {
    case today = "0"
    case week = "7"
    case twoweeks = "14"
    case month = "30"
    case quater = "90"
    case annual = "365"
    //Yes the num of days. 30, 60, 180, 365
}

class FilterViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dueByAnchor: UIImageView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var dueByDateTextField: UITextField!
    var filterArray = [Dictionary<String,Bool>]()
    var segmentIndex = 0
    var selectedfilterArray = [] as Array<Dictionary<String,String>>
    let dueByDateDropDown = DropDown()
    var selecteddueDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    func setUpView() {
        
        if self.segmentIndex == 0 {
            
            switch selecteddueDate {
            case DueDate.today.rawValue:
                self.dueByDateTextField.text = .today
            case DueDate.week.rawValue:
                self.dueByDateTextField.text = .week
            case DueDate.twoweeks.rawValue:
                self.dueByDateTextField.text = .twoweeks
            case DueDate.month.rawValue:
                self.dueByDateTextField.text = .month
            case DueDate.quater.rawValue:
                self.dueByDateTextField.text = .quarter
            case DueDate.annual.rawValue:
                self.dueByDateTextField.text = .annual

            default:
                print("Seleted Dates")
            }


        } else {
            // filterArray = ["SCHEDULED".localized,"IN_PROGRESS".localized,"PENDING_REPORT".localized,"PENDING_PAYMENT".localized,"COMPLETED".localized,"CANCELLED".localized,"WAITING_ON_CANDIDATE".localized,"WAITING_ON_INTERVIEWER".localized,"NO_SHOW".localized,"INCOMPLETED".localized,"CONTRIBUTOR_INTERVIEWS".localized,"MY_INTEVIEWS".localized]
            filterArray = [["MY_JOBS".localized : false],["MY_CONTRIBUTOR_JOBS".localized : false],["ACTIVE".localized : false],["INACTIVE".localized  : false]]
        }
        setupDropDown()

    }
    
    func setupDropDown() {
        
        dueByDateDropDown.direction = .bottom
        dueByDateDropDown.bottomOffset = CGPoint(x: 0, y: 10)
        dueByDateDropDown.backgroundColor = AppTheme.appBackgroundColor
        dueByDateDropDown.dataSource = [None,"TODAY".localized,"WEEK".localized, "TWO_WEEKS".localized, "MONTH".localized, "QUARTER".localized, "ANNUAL".localized]
        dueByDateDropDown.customCellConfiguration = {(index, text, cell) in
                 cell.backgroundColor = AppTheme.appBackgroundColor
                 cell.optionLabel.font = UIFont.appLightFontWith(size: 18.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.filterViewCell, for: indexPath) as! FilterViewCell
        let filter = filterArray[indexPath.row]
        
        for (key,value) in filter {
            cell.filterLabel.text = key
            cell.checkBoxView.isChecked = value
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        
        dueByDateDropDown.anchorView = dueByAnchor
        dueByDateDropDown.show()
        
        dueByDateDropDown.selectionAction = { (index , item ) in
            let selectedItem = item
            if selectedItem == None {
                
                for dict in self.selectedfilterArray {
                    
                    for (key,_) in dict {
                        
                        if key == "due_date" {
                            self.selectedfilterArray.remove(at: index)
                        }
                    }
                }
                
                print("========Deselct====Due Date=========\(self.selectedfilterArray)")
                
                self.dueByDateTextField.text = ""
            } else {
                self.dueByDateTextField.text = selectedItem
            }
        }
        
    }
    
    func appendSelectedFilters() {
        
        for i in 0..<filterArray.count {
            let cell = filterTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? FilterViewCell
            
            if cell?.checkBoxView.isChecked ?? false {
                
                var filter = Dictionary<String,String>()
                if let selectedString = cell?.filterLabel.text {
                    
                    if i == 0 || i == 1 {
                        var jobtype = selectedString
                        if jobtype == "MY_CONTRIBUTOR_JOBS".localized {
                        jobtype =  "My Collaboration"
                        }
                        filter = ["job_type[]":jobtype]
                        
                    } else if i == 2 || i == 3 {
                        filter = ["status[]":selectedString]
                    }
                  
                    selectedfilterArray.append(filter)
                }
            }
        }
        
        let selectedString = self.dueByDateTextField.text ?? ""
        if selectedString != "" {
            
            var duedate = ""
            var filter = Dictionary<String,String>()
            switch selectedString {
            case "TODAY".localized:
                duedate = DueDate.today.rawValue
                
            case "WEEK".localized:
                duedate = DueDate.week.rawValue
                
            case "TWO_WEEKS".localized:
                duedate = DueDate.twoweeks.rawValue
                
            case "MONTH".localized:
                duedate = DueDate.month.rawValue
                
            case "QUARTER".localized:
                duedate = DueDate.quater.rawValue
                
            case "ANNUAL".localized:
                duedate = DueDate.annual.rawValue
            default:
                print("Defalt value")
                break
                
            }
            
            filter = ["due_date[]":duedate]
            selectedfilterArray.append(filter)
        }
    }
    
    func handleFiltersNotifications(type : String) {
        
        self.appendSelectedFilters()
        //print("selectedfilterArray==========================\(selectedfilterArray)")
        if type == "Apply" {
            NotificationCenter.default.post(name: Notification.Name("updatefilters"), object: nil, userInfo: ["filters":selectedfilterArray])
        } else if type == "Save" {
            NotificationCenter.default.post(name: Notification.Name("savedFilters"), object: nil, userInfo: ["filters":selectedfilterArray])
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func applyFilters(_ sender: Any) {
        self.handleFiltersNotifications(type: "Apply")
    }
    
    @IBAction func saveFilters(_ sender: Any) {
        self.handleFiltersNotifications(type: "Save")
    }

}
