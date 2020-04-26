//
//  JobDetailsViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 22/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class JobDetailsViewController: BaseViewController, JobDetailsViewModelDelegate, UIScrollViewDelegate {
    
    var viewModel = JobDetailsViewModel()
    
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var jobDetailstableView: UITableView!
    @IBOutlet weak var jobdetailsView: UIView!
    @IBOutlet weak var requiredSkillsView: UIView!
    @IBOutlet weak var optionalSkillsView: UIView!
    @IBOutlet weak var jobDescriptionView: UIView!
    @IBOutlet weak var requiredSkillsLabel: UILabel!
    @IBOutlet weak var optionalSkillsLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var contentMainView: UIView!
    @IBOutlet weak var jobDetails: UILabel!
    @IBOutlet weak var requiredSkills: UILabel!
    @IBOutlet weak var optionalSkills: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var specialInstructionsLabel: UILabel!
    @IBOutlet weak var specialInstructionsView: UIView!
    
    
    @IBOutlet weak var documentButton: UIButton!
    let documentInteractionController = UIDocumentInteractionController()
    var fileURL = URL(string: "")
    var jobID : String = ""
    var jobResponse =  CreateJobResponse()
     var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        
        self.showSpinner()
        self.viewModel.delegate = self
        self.viewModel.getJobDetails(jobsManager: JobsManager(jobID: self.jobID), requestType: ServerAttributes.getJobDetails)
        
        generateEventLogToAnalytics(eventName: "Job Description Event", status: "True")
        // Do any additional setup after loading the view.
                
    }
    
    func setupView() {
        jobdetailsView.layer.borderWidth = 1
        jobdetailsView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        jobdetailsView.layer.cornerRadius = 5
        requiredSkillsView.layer.borderWidth = 1
        requiredSkillsView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        requiredSkillsView.layer.cornerRadius = 5
        optionalSkillsView.layer.borderWidth = 1
        optionalSkillsView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        optionalSkillsView.layer.cornerRadius = 5
        jobDescriptionView.layer.borderWidth = 1
        jobDescriptionView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        jobDescriptionView.layer.cornerRadius = 5
        specialInstructionsView.layer.borderWidth = 1
        specialInstructionsView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        specialInstructionsView.layer.cornerRadius = 5
        jobDetails.bold(size: 16)
        requiredSkills.bold(size: 16)
        optionalSkills.bold(size: 16)
        jobDescriptionLabel.bold(size: 16)
        specialInstructionsLabel.bold(size: 16)
        requiredSkillsLabel.light(size: 16)
        optionalSkillsLabel.light(size: 16)
        descriptionLabel.light(size: 16)
        instructionsLabel.light(size: 16)
        self.setUpNavigationBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        bgScrollView.contentSize = CGSize(width: view.frame.size.width, height: self.specialInstructionsView.frame.maxY+20)
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension JobDetailsViewController {
    
    func onAPIException(errorResponse: ErrorResponse?, requestType: String?) {
        
        DispatchQueue.main.async {
            self.removeSpinner()
            guard let message = errorResponse?.message else {return}
            self.showBanner(title: "", withMessage: message, style: .warning)
        }
    }
    
    func onGetAPIResponse(response: CreateJobResponse?, requestType: String?) {
        
        DispatchQueue.main.async {
            
            if response?.skillset != "" {self.requiredSkillsLabel.text = response?.skillset}
            if let preferedSkil = response?.preferedSkillSet  {
                if preferedSkil != "" {self.optionalSkillsLabel.text = preferedSkil}
            }
            if response?.jobDescription != "" {
                self.descriptionLabel.text = response?.jobDescription
                
                if self.descriptionLabel.text == "" {
                    self.descriptionLabel.text = None
                }
                
            }
            
            if self.descriptionLabel.text == "" {
                              self.descriptionLabel.text = None
            }
            
            if response?.specialInstructions != "" {
                self.instructionsLabel.text = response?.specialInstructions
            }
            
            if response?.jobTitle != "" {self.navigationItem.title = response?.jobTitle}
            if let response  = response {
                self.jobResponse = response
                //self.downloadDocument()
                                
                let fileURLString = response.jobDescriptionAwsurl ?? ""
                
                if fileURLString != ""{
                
                    self.documentButton.isHidden = false
                    self.documentImageView.isHidden = false
                    
                    let fileurl =  URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                    if fileurl?.pathExtension == "pdf" {
                        self.documentImageView.image = UIImage(named: "pdf_icon")
                    } else if fileurl?.pathExtension == "" {
                        self.documentImageView.image = UIImage(named: "")
                        self.documentButton.isHidden = true
                        self.documentImageView.isHidden = true

                    } else {
                        self.documentImageView.image = UIImage(named: "document_icon")
                    }

                } else {
                    
                    self.documentButton.isHidden = true
                    self.documentImageView.isHidden = true
                }
                self.jobDetailstableView.reloadData()
                self.removeSpinner()
            }
            
        }
        
    }
    
}

extension JobDetailsViewController {
    
    @IBAction func documentDowloadAction(_ sender: Any) {
        
        self.showSpinner()
        
        DispatchQueue.main.async {
            
            self.downloadDocument()
            
        }
        
    }
    
    func downloadDocument() {
        
      
        let fileURLString = jobResponse.jobDescriptionAwsurl ?? ""
        print(fileURLString)
        
        if let fileURL = URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            
            self.loadFileAsync(url: fileURL) { (result,path) in
                
                if result {
                    print("File Saved at \(path)")
                    let appendString = "file://" + path
                    self.fileURL = URL(string: appendString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    DispatchQueue.main.async {
                        self.documentInteractionController.url = self.fileURL
                        self.documentInteractionController.uti = self.fileURL?.typeIdentifier ?? "public.data, public.content"
                        self.documentInteractionController.name = self.fileURL?.localizedName ?? self.fileURL?.lastPathComponent
                        self.documentInteractionController.delegate = self
                        self.documentInteractionController.presentPreview(animated: true)
                    }
                    
        
                } else {
                    self.showBanner(title: "", withMessage: "File not saved.", style: .warning)
                    print("File Not Saved \(path)")
                }
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
                
            }
            
        }
    }

}

extension JobDetailsViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

extension JobDetailsViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


extension BaseViewController {
    // Downloads a file asynchronously
    func loadFileAsync(url: URL, completion: @escaping (Bool,String) -> Void) {
        
        // create your document folder url
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // your destination file url
        let destination = documentsUrl.appendingPathComponent(url.lastPathComponent)
        print("downloading file from URL: \(url.absoluteString)")
        
        if FileManager().fileExists(atPath: destination.path) {
            print("The file already exists at path, deleting and replacing with latest")
            
            if FileManager().isDeletableFile(atPath: destination.path){
                do{
                    try FileManager().removeItem(at: destination)
                    print("previous file deleted")
                    self.saveFile(url: url, destination: destination) { (complete,destinationPath) in
                        if complete{
                            completion(true,destinationPath)
                        } else {
                            completion(false,destinationPath)
                        }
                    }
                }catch{
                    print("current file could not be deleted")
                }
            }
            // download the data from your url
        } else {
            self.saveFile(url: url, destination: destination) { (complete,destinationPath) in
                if complete{
                    completion(true,destinationPath)
                } else {
                    completion(false,destinationPath)
                }
            }
        }
    }
    
    
    func saveFile(url: URL, destination: URL, completion: @escaping (Bool,String) -> Void){
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let location = location, error == nil
                else { print("error with the url response"); completion(false,"failed"); return}
            do {
                try FileManager.default.moveItem(at: location, to: destination)
                print("new file saved")
                completion(true,destination.path)
            } catch {
                print("file could not be saved: \(error)")
                completion(false,"Failed")
            }
        }).resume()
    }
}

extension JobDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = jobDetailstableView.dequeueReusableCell(withIdentifier: CellIdentifiers.jobDetailsCell) as? JobDetailsCell
        //
        
        switch indexPath.row {
            
        case 0:
            
            cell?.detailsKey.text = "JOB_REQUISITION_NUMBER".localized
            
            if let jobCode = jobResponse.jobCode {
                
                if jobCode != "" {
                    cell?.detailsValues.text = "\(jobCode)"
                }
            }
            
        case 1:
            
            cell?.detailsKey.text = "AGENT_TYPE".localized
            
            if let agent = jobResponse.agent {
                
                if agent != "" {
                    cell?.detailsValues.text = agent
                    
                }
            }
            
            
        case 2:
            
            cell?.detailsKey.text = "LANGUAGE_PREFERENCE".localized
            
            if let laguange = jobResponse.interViewLanguagePreference {
                
                if laguange != "" {
                    cell?.detailsValues.text = laguange
                    
                }
            }
            
            
            
        case 3:
            
            cell?.detailsKey.text = "LOCATION_PREFERENCE".localized
            
            if let location = jobResponse.interViewLocationPreference {
                
                if location != "" {
                    cell?.detailsValues.text = location
                    
                }
                
            }
            
        case 4:
            
            cell?.detailsKey.text = "HIRING_COMPANY_NAME".localized
            
            if let clientCompany = jobResponse.clientCompanyName {
                
                if clientCompany != "" {
                    cell?.detailsValues.text = clientCompany
                    
                }
            }
            
            
            
        case 5:
            
            cell?.detailsKey.text = "NUMBER_OF_CANDIDATES".localized
            
            
            
            if let candidates = jobResponse.numberOfProspects {
                
                cell?.detailsValues.text = "\(candidates)"
                
            }
            
            
            
            
        case 6:
            
            cell?.detailsKey.text = "YEARS_OF_EXPERIENCE".localized
            
            if let experience = jobResponse.experirenceRequired {
                
                cell?.detailsValues.text = "\(experience)"
                
            }
            
            
        case 7:
            
            cell?.detailsKey.text = "CLOSING_DATE".localized
            if let closingDate = jobResponse.dueDate {
                
                if closingDate != "" {
                    cell?.detailsValues.text = closingDate.changeCurrentDate(closingDate)
                    
                }
            }
            
         case 8:
         
           cell?.detailsKey.text = "CANDIDATE_PIC_ID".localized
           if let status = jobResponse.idRequired {
               if status {
                   cell?.detailsValues.text = Yes
               } else {
                   cell?.detailsValues.text = No
               }
           }
         
        case 9:
        
          cell?.detailsKey.text = "CODE_SAMPLES".localized
          if let status = jobResponse.codingRequired {
              if status {
                  cell?.detailsValues.text = Yes
              } else {
                  cell?.detailsValues.text = No
              }
          }
        
        case 10:
        
          cell?.detailsKey.text = "WHITEBOARD_SNAPSHOTS".localized
          if let status = jobResponse.whiteboradRequired {
            if status {
                cell?.detailsValues.text = Yes
            } else {
                cell?.detailsValues.text = No
            }
        }
        default: fatalError("Unhandled section \(indexPath.section)")
        }
         
        cell?.detailsKey.light(size: 16)
        cell?.detailsValues.light(size: 16)
        return cell!
    }
}
