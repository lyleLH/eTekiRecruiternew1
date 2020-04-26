//
//  EscalationsVC.swift
//  sampleNew
//
//  Created by Kartheek Repakula on 14/04/20.
//  Copyright © 2020 Kartheek Repakula. All rights reserved.
//

import UIKit
import iOSDropDown

class EscalationsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var searchDropDown: DropDown!
    @IBOutlet weak var escalationTV: UITableView!
     var selectTv = ""
    
    struct esclationsData {
        var jobName : String
        var interviewDate : String
        var candidateName : String
        var raisedTime : String
        var resolvedTime : String
        var refundedAmt : String
        var discountAmt : String
        var type: String
    }
    
    var escalationsArray = [esclationsData]()
    var selectedArray = [esclationsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButtonItems(self.menuItem, animated: true)
        
        hideNotificationButton()
        
        escalationsArray.append(esclationsData(
            jobName: "Java Developer",
            interviewDate: "01/23/1994",
            candidateName: "Bindu",
            raisedTime: "02/20/2020 11:20 AM",
            resolvedTime: "02/28/2020 10:20 PM",
            refundedAmt: "$ 200:00",
            discountAmt: "$ 300:90",
            type: "Resolved"))
        
        escalationsArray.append(esclationsData(
        jobName: "iOS Developer",
        interviewDate: "12/11/1992",
        candidateName: "Maheshwari",
        raisedTime: "02/20/2020 10:00 AM",
        resolvedTime: "02/28/2020 6:00 PM",
        refundedAmt: "$ 1,000:00",
        discountAmt: "$ 10,000:90",
        type: "Raised"))
        
        escalationsArray.append(esclationsData(
        jobName: "Front end Developer",
        interviewDate: "07/18/2001",
        candidateName: "Madhushalini",
        raisedTime: "02/20/2020 09:00 AM",
        resolvedTime: "02/28/2020 6:00 PM",
        refundedAmt: "$ 220:00",
        discountAmt: "$ 150:90",
        type: "In-Progress"))
        
        escalationsArray.append(esclationsData(
        jobName: "Back end developer",
        interviewDate: "05/09/2000",
        candidateName: "Sravani",
        raisedTime: "02/20/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 200:00",
        discountAmt: "$ 300:90",
        type: "Raised"))
        
        escalationsArray.append(esclationsData(
        jobName: "Php Dev",
        interviewDate: "01/23/1994",
        candidateName: "Bindu",
        raisedTime: "02/20/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 200:00",
        discountAmt: "$ 300:90",
        type: "In-Progress"))
        
        escalationsArray.append(esclationsData(
        jobName: "Animation artist",
        interviewDate: "01/23/1994",
        candidateName: "Bindu",
        raisedTime: "02/20/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 200:00",
        discountAmt: "$ 300:90",
        type: "In-Progress"))
        
        escalationsArray.append(esclationsData(
        jobName: "Visual effects artist",
        interviewDate: "01/23/1994",
        candidateName: "Jyothsna",
        raisedTime: "02/04/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 400:00",
        discountAmt: "$ 100:90",
        type: "In-Progress"))
        
        escalationsArray.append(esclationsData(
        jobName: "Agri analyist",
        interviewDate: "01/23/1995",
        candidateName: "Priya",
        raisedTime: "02/04/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 20:00",
        discountAmt: "$ 100:90",
        type: "Raised"))
        
        escalationsArray.append(esclationsData(
        jobName: "Pichi analyist",
        interviewDate: "01/23/1995",
        candidateName: "Harshitha",
        raisedTime: "02/04/2020 11:20 AM",
        resolvedTime: "02/28/2020 10:20 PM",
        refundedAmt: "$ 0:00",
        discountAmt: "$ 100:90",
        type: "Resolved"))
        
        
        

        searchDropDown.checkMarkEnabled = false
        searchDropDown.optionArray = ["All","Resolved", "Raised", "In-Progress"]
           //Its Id Values and its optional
        searchDropDown.optionIds = [1,23,54,22]
        searchDropDown.selectedRowColor = .gray
        
        searchDropDown.text = searchDropDown.optionArray[0]
        selectTv = searchDropDown.text ?? ""
        searchDropDown.selectedIndex = 0
        //searchDropDown.selectedIndex=0
           // Image Array its optional
          // searchDropDown.ImageArray = [👩🏻‍🦳,🙊,🥞]
           // The the Closure returns Selected Index and String
           searchDropDown.didSelect{(selectedText , index ,id) in
            
            self.selectTv = selectedText
          // self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
            self.escalationTV.reloadData()
            
           }
        // Do any additional setup after loading the view.
    }

   
   override func viewWillAppear(_ animated: Bool) {
       setNavigationBarColor(color: AppTheme.statusBarDefaultColor)
   }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(selectedArray.count > 0){
            selectedArray.removeAll()
        }
        if(self.selectTv == "Raised"){
            
            for myarr in self.escalationsArray {
                if(myarr.type == "Raised"){
                    selectedArray.append(myarr)
                }
               
            }
            return selectedArray.count
        }else if(self.selectTv == "Resolved"){
            
            for myarr in self.escalationsArray {
                if(myarr.type == "Resolved"){
                    selectedArray.append(myarr)
                }
            }
            return selectedArray.count
        }else if(self.selectTv == "In-Progress"){
           
                       for myarr in self.escalationsArray {
                           if(myarr.type == "In-Progress"){
                               selectedArray.append(myarr)
                           }
                          
                       }
            return selectedArray.count
        }else{
            return self.escalationsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "raised", for: indexPath) as! ContentTableViewCell
        if selectTv == "Raised"
        {
            cell.jobTitle.text = selectedArray[indexPath.row].jobName
            cell.jobTitle.font = UIFont.appBoldFontWith(size: 18)
            cell.jobTitle.textColor = #colorLiteral(red: 0.287966609, green: 0.2879741788, blue: 0.2879701257, alpha: 0.8470588235)
            cell.statusLbl.text = selectedArray[indexPath.row].type
            
            cell.statusLbl.text = "Raised"
            cell.statusLbl.textColor = #colorLiteral(red: 1, green: 0.007843137255, blue: 0.007843137255, alpha: 1)
            cell.statusLbl.font = UIFont.appBoldFontWith(size: 12)
        }
        
        else if selectTv == "Resolved"
        {
            cell.jobTitle.text = selectedArray[indexPath.row].jobName
            cell.statusLbl.text = selectedArray[indexPath.row].type
            
            cell.statusLbl.text = "Resolved"
            cell.statusLbl.textColor = #colorLiteral(red: 0.1215686275, green: 0.7725490196, blue: 0.01960784314, alpha: 1)
        }
            else if selectTv == "In-Progress"
            {
                cell.jobTitle.text = selectedArray[indexPath.row].jobName
                cell.statusLbl.text = selectedArray[indexPath.row].type
                cell.statusLbl.text = "In-Progress"
                cell.statusLbl.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            }
        else
        {
            cell.jobTitle.text = escalationsArray[indexPath.row].jobName
            cell.statusLbl.text = escalationsArray[indexPath.row].type
             cell.statusLbl.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        
        
        
         cell.backView.backgroundColor = .white
         //cell.backView.layer.cornerRadius = 10.0
         cell.backView.layer.shadowColor = UIColor.gray.cgColor
         cell.backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
         cell.backView.layer.shadowRadius = 3.0
         cell.backView.layer.shadowOpacity = 0.3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }


   
}
