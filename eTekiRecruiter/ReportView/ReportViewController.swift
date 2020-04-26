//
//  ReportViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 27/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import AVKit
import Charts
import JJFloatingActionButton




 class ReportViewController: BaseViewController, AVAudioPlayerDelegate  {
    
    
    
    lazy var customBackItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 12.0, width: 12.0, height: 20.5))
        imageView.image = UIImage(named: "Back")
        imageView.contentMode = .scaleAspectFit
        let back = UIButton(type: .custom)
        back.frame.size.width = 50.0
        back.frame.size.height = 44.0
        back.addTarget(self, action: #selector(customBackAction(_:)), for: .touchUpInside)
        customView.addSubview(imageView)
        customView.addSubview(back)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    @IBOutlet weak var summaryScoreLabel: UILabel!
    @IBOutlet weak var noAuidosLabel: UILabel!
    @IBOutlet weak var noVideosLabel: UILabel!
    var videosArray = [String]()
    var audiosArray = [String]()
    
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var codeTableView: UITableView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var skillsBarchartView: BarChartView!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var summaryHeader: UILabel!
    
    
    let skillsParties = ["Competency Score", "Experience Score"]
    
    var options: [Option]!
    var shouldHideData: Bool = false
    var codeTypes = [Dictionary<String,[String]>]()
    var codeTitles = [String]()
    var reportStatus = String()
    var summaryScore = ""
    
    @IBOutlet weak var noCodeData: UILabel!
    @IBOutlet weak var scrollableSegment: ScrollableSegmentedControl!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var skillsView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var noImagesToShow: UILabel!
    @IBOutlet weak var reportStackView: UIStackView!
    var images = [String]()
    var selectedIndexPath: NSIndexPath?
    var thumbImage = UIImage()
    var interviewCode = ""
    var interviewReportId = ""
    var jobId = ""
    var candidateCaptureImageUrl = ""
    var isGrievanceEnabled = false
    var candidateFirstName = ""
    var viewModel =  ReportViewModel()
    var screenName = "Report Screen"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSegmentContoller()
        self.setupFloatingButton()
        self.navigationItem.setLeftBarButtonItems(self.customBackItem, animated: false)
        self.bindViewModel()
        setUpNavigationBar()
        setupView()
        
    }
    
    
    

    
    @objc func customBackAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func bindViewModel() {
        self.viewModel.delegate = self
        self.viewModel.skillstableViewData = [SkillsData(opened: false, title: Skills.requiredSkills, sectionData: []),SkillsData(opened: false, title: Skills.optionalSkills, sectionData: [])]
        self.showSpinner()
        self.viewModel.getReportViewDetails(interviewCode: interviewCode)
    }

    /*
     func getReportViewDetails() {

     self.showSpinner()
     self.candidatesAPI.getReportViewDetails(candidateManger: CandidatesManager(interviewCode: self.interviewCode)) {(response , error) in
     if(response != nil) {
     let success = response?["success"] as? Bool ?? false
     if(success) {
     DispatchQueue.main.async {
     if let reportSkills = response?["report_skills"] as? [Dictionary<String, Any>]  {

     print(reportSkills)
     for i in 0..<reportSkills.count {
     if reportSkills[i]["skill_competency"] as? String == "Required" {
     self.skillstableViewData[0].sectionData.append(reportSkills[i])
     } else if(reportSkills[i]["skill_competency"] as? String == "Preferred") {
     self.skillstableViewData[1].sectionData.append(reportSkills[i])
     }
     }
     }

     if let videos = response?["videos"] as? [Dictionary<String,Any>] {

     if self.videosArray.count > 0 {
     self.videosArray.removeAll()
     }

     for dict in videos {
     if let videoURL = dict["url"] as? String {
     self.videosArray.append(videoURL)
     }
     }
     } else {
     print("Unable to parse videos")
     }

     if self.videosArray.count != 0 {

     self.noVideosLabel.isHidden = true
     self.videosTableView.isHidden = false
     } else {
     self.noVideosLabel.isHidden = false
     self.videosTableView.isHidden = true
     }

     if let audios = response?["audios"] as? [Dictionary<String,Any>] {

     if self.audiosArray.count > 0 {
     self.audiosArray.removeAll()
     }
     for dict in audios {
     if let audioURL = dict["url"] as? String {
     self.audiosArray.append(audioURL)
     }
     }
     } else {
     print("Unable to parse audios")
     }

     if self.audiosArray.count != 0 {
     self.noAuidosLabel.isHidden = true
     self.audioTableView.isHidden = false
     } else {
     self.noAuidosLabel.isHidden = false
     self.audioTableView.isHidden = true
     }


     if let imageUrls = response?["image_urls"] as? [String] {
     self.images = imageUrls
     //self.imagesCollectionView.reloadData()
     }
     if let id = response?["report_id"] as? Int{
     self.interviewReportId = "\(id)"
     }

     if let jobDetails = response?["job"] as? Dictionary<String, Any>{
     if let id = jobDetails["id"] as? Int{
     self.jobId = "\(id)"
     }
     }

     if let candidateDetails = response?["candidate"] as? Dictionary<String, Any> {
     if let caputureImage = candidateDetails["capture_id_url"] as? String{
     self.candidateCaptureImageUrl = caputureImage
     }
     if let name = candidateDetails["first_name"] as? String {
     self.candidateFirstName = name
     self.navigationItem.title = name + " " + "Report"
     }
     }

     if let grievance_period_val = response?["grievance_period"] as? Bool{
     self.grievance_period_Value = grievance_period_val
     self.setupFloatingButton()
     }

     self.codeTableViewData = []
     if let codes = response?["code"] as? [Dictionary<String, Any>] {

     for i in 0..<codes.count {

     let codeDict = codes[i]
     let codeURL = codeDict["code"] as? String ?? ""

     // Below code need to be revised as it makes the load slow
     var contents = ""
     if let url = URL(string: codeURL) {
     do {
     contents = try String(contentsOf: url)
     print(contents)
     } catch {
     // contents could not be loaded
     }
     } else {
     // the URL was bad!
     }

     let val = contents.components(separatedBy: "\n")
     let title = val[0].components(separatedBy: ": ")
     contents = ""
     for i in 2..<val.count {
     contents = contents + val[i] + "\n"
     }

     let currentkey = title[1]

     if !self.codeTitles.contains(currentkey) {
     self.codeTitles.append(currentkey)
     self.codeTypes.append([currentkey : [contents]])
     } else {

     for j in 0..<self.codeTypes.count {
     var content = self.codeTypes[j]
     var contentArray =  content[currentkey]
     contentArray?.append(contents)
     content[currentkey] = contentArray
     self.codeTypes[j] = content
     }

     }
     }
     }

     for i in 0..<self.codeTitles.count {

     let title = self.codeTitles[i]

     for j in 0..<self.codeTypes.count {
     let dict = self.codeTypes[j]

     for (key,value) in dict {

     if key == title {

     self.codeTableViewData.append(CodeData(opened: false, title: title,sectionData: value))

     }
     }
     }

     }
     if let summary = response?["professional_background"] as? String {
     self.summaryTextView.text = summary
     }

     if let experience_rating = response?["average_ratings"] as? Dictionary<String, Any> {
     self.averageCompentancyScore = []
     if let preferred = experience_rating["required_skill_avg_rating"] as? String{
     self.averageCompentancyScore.append(Double(preferred) ?? 0.0)
     } else {
     self.averageCompentancyScore.append(0.0)
     }

     if let required = experience_rating["preferred_skill_avg_rating"] as? String {
     self.averageCompentancyScore.append(Double(required) ?? 0.0)
     } else {
     self.averageCompentancyScore.append(0.0)
     }

     if let score = experience_rating["qumilative_skill_avg_rating"] as? String {
     self.summaryScore = "\(Double(score) ?? 0.0)"
     } else {
     self.summaryScore = "0.0"
     }

     }
     if let summary = response?["professional_background"] as? String {
     self.summaryTextView.text = summary
     }

     if let experience_rating = response?["average_ratings"] as? Dictionary<String, Any> {
     self.averageCompentancyScore = []
     if let preferred = experience_rating["required_skill_avg_rating"] as? String{
     self.averageCompentancyScore.append(Double(preferred) ?? 0.0)
     } else {
     self.averageCompentancyScore.append(0.0)
     }

     if let required = experience_rating["preferred_skill_avg_rating"] as? String {
     self.averageCompentancyScore.append(Double(required) ?? 0.0)
     } else {
     self.averageCompentancyScore.append(0.0)
     }

     }

     if let experience_rating = response?["average_experience_ratings"] as? Dictionary<String, Any> {
     self.averageExperienceScore = []
     if let required = experience_rating["required_experience_score_rating"] as? String {
     self.averageExperienceScore.append(Double(required) ?? 0.0)
     } else {
     self.averageExperienceScore.append(0.0)
     }

     if let preferred = experience_rating["preferred_experience_score_rating"] as? String{
     self.averageExperienceScore.append(Double(preferred) ?? 0.0)
     } else {
     self.averageExperienceScore.append(0.0)
     }
     }

     if let status = response?["report_status"] as? String {
     self.reportStatus = status
     }
     self.loadChartView()
     self.removeSpinner()
     }
     } else {
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
     }*/
    
    func setupSegmentContoller() {
        
        scrollableSegment.layer.borderColor = AppTheme.containerBorderColor.cgColor
        scrollableSegment.layer.borderWidth = 1
        scrollableSegment.layer.cornerRadius = 5
        scrollableSegment.segmentStyle = .textOnly
        
        scrollableSegment.insertSegment(withTitle: "SCORE".localized, at: 0)
        scrollableSegment.insertSegment(withTitle: "VIDEOS".localized, at: 1)
        scrollableSegment.insertSegment(withTitle: "AUDIOS".localized, at: 2)
        scrollableSegment.insertSegment(withTitle: "SKILLS".localized, at: 3)
        scrollableSegment.insertSegment(withTitle: "CODE".localized, at: 4)
        scrollableSegment.insertSegment(withTitle: "WHITEBOARD".localized, at: 5)
        
        scrollableSegment.underlineSelected = true
        scrollableSegment.tintColor = AppTheme.brandColor
        
        // change some colors
        scrollableSegment.segmentContentColor = UIColor.black
        scrollableSegment.selectedSegmentContentColor = AppTheme.brandColor
        scrollableSegment.backgroundColor = .white
        scrollableSegment.fixedSegmentWidth = true

        self.updateSegementController()
        
    }
    
    @IBAction func segmentValueChange(_ sender: Any) {
        
        
        let currentIndex = scrollableSegment.selectedSegmentIndex
        
        switch currentIndex {
        case 0:
            scoreView.isHidden = false
            audioView.isHidden = true
            videoView.isHidden = true
            skillsView.isHidden = true
            codeView.isHidden = true
            imagesView.isHidden = true
        case 1:
            scoreView.isHidden = true
            audioView.isHidden = true
            videoView.isHidden = false
            skillsView.isHidden = true
            codeView.isHidden = true
            imagesView.isHidden = true
        case 2:
            scoreView.isHidden = true
            audioView.isHidden = false
            videoView.isHidden = true
            skillsView.isHidden = true
            codeView.isHidden = true
            imagesView.isHidden = true
        case 3:
            scoreView.isHidden = true
            audioView.isHidden = true
            videoView.isHidden = true
            skillsView.isHidden = false
            codeView.isHidden = true
            imagesView.isHidden = true
        case 4:
            scoreView.isHidden = true
            audioView.isHidden = true
            videoView.isHidden = true
            skillsView.isHidden = true
            codeView.isHidden = false
            imagesView.isHidden = true
            DispatchQueue.main.async {
                if !self.viewModel.codeTableViewData.isEmpty {
                    self.codeTableView.isHidden = false
                    self.noCodeData.isHidden = true
                    self.codeTableView.reloadData()
                } else {
                    self.codeTableView.isHidden = true
                    self.noCodeData.isHidden = false
                }
            }
        case 5:
            scoreView.isHidden = true
            audioView.isHidden = true
            videoView.isHidden = true
            skillsView.isHidden = true
            codeView.isHidden = true
            imagesView.isHidden = false
            
            DispatchQueue.main.async {
                if self.images.isEmpty {
                    self.imagesCollectionView.isHidden = true
                    self.noImagesToShow.isHidden = false
                } else {
                    self.imagesCollectionView.isHidden = false
                    self.noImagesToShow.isHidden = true
                    self.imagesCollectionView.delegate = self
                    self.imagesCollectionView.dataSource = self
                    self.imagesCollectionView.reloadData()
                }
            }
        default:
            print("Switch at default")
        }
    }
    
    func updateSegementController() {
        
        if #available(iOS 13.0, *) {
            scrollableSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : AppTheme.brandColor], for: .selected)
            scrollableSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : DashBoardScreenFonts.segementTitleColor], for: .disabled)
            self.scrollableSegment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.appLightFontWith(size: 16.0)], for: .normal)
            self.scrollableSegment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.appLightFontWith(size: 16.0)], for: .selected)

            scrollableSegment.layer.borderWidth = 1.0
            scrollableSegment.layer.borderColor = AppTheme.brandColor.cgColor
            scrollableSegment.layer.shadowColor = AppTheme.shadowColor.cgColor
            scrollableSegment.layer.borderColor = AppTheme.brandColor.cgColor
            scrollableSegment.clipsToBounds = true
        } else {
            let fontAttribute = [NSAttributedString.Key.font: UIFont.appLightFontWith(size: 16.0),
                                 NSAttributedString.Key.foregroundColor: DashBoardScreenFonts.segementTitleColor]
            scrollableSegment.setTitleTextAttributes(fontAttribute as [NSAttributedString.Key : Any], for: .normal)
            scrollableSegment.layer.borderColor = AppTheme.brandColor.cgColor
        }
        scrollableSegment.selectedSegmentIndex = 0
        scoreView.isHidden = false
        imagesCollectionView.delegate = nil
        imagesCollectionView.dataSource = nil
    }
}

extension ReportViewController : ReportViewModelDelegate {

    func updateReportDetails(response: [String : Any]?) {

        if(response != nil) {
            let success = response?["success"] as? Bool ?? false
            if(success) {
                DispatchQueue.main.async {
                    if let reportSkills = response?["report_skills"] as? [[String : Any]]  {

                        for index in 0..<reportSkills.count {
                            if reportSkills[index]["skill_competency"] as? String == "Required" {
                                self.viewModel.skillstableViewData[0].sectionData.append(reportSkills[index])
                            } else if(reportSkills[index]["skill_competency"] as? String == "Preferred") {
                                self.viewModel.skillstableViewData[1].sectionData.append(reportSkills[index])
                            }
                        }
                    }

                    if let videos = response?["videos"] as? [[String : Any]] {

                        if !self.videosArray.isEmpty {
                            self.videosArray.removeAll()
                        }
                        for dict in videos {
                            if let videoURL = dict["url"] as? String {
                                self.videosArray.append(videoURL)
                            }
                        }
                    } else {
                        print("Unable to parse videos")
                    }

                    if !self.videosArray.isEmpty {
                        self.noVideosLabel.isHidden = true
                        self.videosTableView.isHidden = false
                    } else {
                        self.noVideosLabel.isHidden = false
                        self.videosTableView.isHidden = true
                    }

                    if let audios = response?["audios"] as? [[String : Any]] {

                        if !self.audiosArray.isEmpty {
                            self.audiosArray.removeAll()
                        }
                        for dict in audios {
                            if let audioURL = dict["url"] as? String {
                                self.audiosArray.append(audioURL)
                            }
                        }
                    } else {
                        print("Unable to parse audios")
                    }

                    if !self.audiosArray.isEmpty {
                        self.noAuidosLabel.isHidden = true
                        self.audioTableView.isHidden = false
                    } else {
                        self.noAuidosLabel.isHidden = false
                        self.audioTableView.isHidden = true
                    }

                    if let imageUrls = response?["image_urls"] as? [String] {
                        self.images = imageUrls
                        //self.imagesCollectionView.reloadData()
                    }
                    if let reportID = response?["report_id"] as? Int {
                        self.interviewReportId = "\(reportID)"
                    }

                    if let jobDetails = response?["job"] as? [String : Any] {
                        if let jobID = jobDetails["id"] as? Int {
                            self.jobId = "\(jobID)"
                        }
                    }

                    if let candidateDetails = response?["candidate"] as? [String : Any] {
                        if let caputureImage = candidateDetails["capture_id_url"] as? String {
                            self.candidateCaptureImageUrl = caputureImage
                        }
                        if let name = candidateDetails["first_name"] as? String {
                            self.candidateFirstName = name
                            self.navigationItem.title = name + " " + "Report"
                        }
                    }

                    if let isGrievanceEnabled = response?["grievance_period"] as? Bool {
                        self.isGrievanceEnabled = isGrievanceEnabled
                        self.setupFloatingButton()
                    }

                    self.viewModel.codeTableViewData = []
                    if let codes = response?["code"] as? [[String : Any]] {

                        for index in 0..<codes.count {

                            let codeDict = codes[index]
                            let codeURL = codeDict["code"] as? String ?? ""

                            // Below code need to be revised as it makes the load slow
                            var contents = ""
                            if let url = URL(string: codeURL) {
                                do {
                                    contents = try String(contentsOf: url)
                                    print(contents)
                                } catch {
                                    // contents could not be loaded
                                }
                            } else {
                                // the URL was bad!
                            }

                            let val = contents.components(separatedBy: "\n")
                            let title = val[0].components(separatedBy: ": ")
                            contents = ""
                            for index in 2..<val.count {
                                contents += val[index] + "\n"
                            }

                            let currentkey = title[1]

                            if !self.codeTitles.contains(currentkey) {
                                self.codeTitles.append(currentkey)
                                self.codeTypes.append([currentkey : [contents]])
                            } else {

                                for jack in 0..<self.codeTypes.count {
                                    var content = self.codeTypes[jack]
                                    var contentArray =  content[currentkey]
                                    contentArray?.append(contents)
                                    content[currentkey] = contentArray
                                    self.codeTypes[jack] = content
                                }

                            }
                        }
                    }

                    for index in 0..<self.codeTitles.count {

                        let title = self.codeTitles[index]

                        for jack in 0..<self.codeTypes.count {
                            let dict = self.codeTypes[jack]

                            for (key,value) in dict {

                                if key == title {
                                    self.viewModel.codeTableViewData.append(CodeData(opened: false, title: title,sectionData: value))

                                }
                            }
                        }

                    }
                    if let summary = response?["professional_background"] as? String {
                        self.summaryTextView.text = summary
                    }

                    if let averageRatings = response?["average_ratings"] as? [String : Any] {
                        self.viewModel.averageCompentancyScore = []
                        if let preferred = averageRatings["required_skill_avg_rating"] as? String {
                            self.viewModel.averageCompentancyScore.append(Double(preferred) ?? 0.0)
                        } else {
                            self.viewModel.averageCompentancyScore.append(0.0)
                        }

                        if let required = averageRatings["preferred_skill_avg_rating"] as? String {
                            self.viewModel.averageCompentancyScore.append(Double(required) ?? 0.0)
                        } else {
                            self.viewModel.averageCompentancyScore.append(0.0)
                        }

                        if let score = averageRatings["qumilative_skill_avg_rating"] as? String {
                             let score = Double(score)
                            self.summaryScore = String(format: "%.2f", score ?? 0.00)
                        } else {
                            self.summaryScore = "0.00"
                        }

                    }

                    if let summary = response?["professional_background"] as? String {
                        self.summaryTextView.text = summary
                    }

                    //                    if let averageRatings = response?["average_ratings"] as? Dictionary<String, Any> {
                    //                        self.viewModel.averageCompentancyScore = []
                    //                        if let preferred = averageRatings["required_skill_avg_rating"] as? String{
                    //                            self.viewModel.averageCompentancyScore.append(Double(preferred) ?? 0.0)
                    //                        } else {
                    //                            self.viewModel.averageCompentancyScore.append(0.0)
                    //                        }
                    //
                    //                        if let required = averageRatings["preferred_skill_avg_rating"] as? String {
                    //                            self.viewModel.averageCompentancyScore.append(Double(required) ?? 0.0)
                    //                        } else {
                    //                            self.viewModel.averageCompentancyScore.append(0.0)
                    //                        }
                    //
                    //                    }

                    if let averageExperienceRatings = response?["average_experience_ratings"] as? Dictionary<String, Any> {
                        self.viewModel.averageExperienceScore = []
                        if let required = averageExperienceRatings["required_experience_score_rating"] as? String {
                            self.viewModel.averageExperienceScore.append(Double(required) ?? 0.0)
                        } else {
                            self.viewModel.averageExperienceScore.append(0.0)
                        }

                        if let preferred = averageExperienceRatings["preferred_experience_score_rating"] as? String {
                            self.viewModel.averageExperienceScore.append(Double(preferred) ?? 0.0)
                        } else {
                            self.viewModel.averageExperienceScore.append(0.0)
                        }
                    }

                    if let status = response?["report_status"] as? String {
                        self.reportStatus = status
                    }
                    self.loadChartView()
                    self.removeSpinner()
                }
            } else {
                self.showBanner(title: "", withMessage: .unkownServerError, style: .danger)
            }
        }
    }

    func updateErrorReponse(errorResponse: ErrorResponse?) {
        guard let message = errorResponse?.message else {return}
        self.handleErrorResponse(message: message)
    }

}

extension ReportViewController {
    
    func setupFloatingButton() {
        let actionButton = JJFloatingActionButton()
        
        actionButton.addItem(title: "", image: UIImage(named: "pencil_float")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportToFeedback, sender: nil)
        }
        
        actionButton.addItem(title: "", image: UIImage(named: "share_float")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportViewToShare, sender: nil)
        }
        
//        if isGrievanceEnabled {
//            actionButton.addItem(title: "", image: UIImage(named: "revert_float")?.withRenderingMode(.alwaysTemplate)) { item in
//                // do something
//                if(self.reportStatus == RevertReport.requestEditsAdmin || self.reportStatus == RevertReport.requestEditsRecruiter || self.reportStatus == RevertReport.pendingAdminApproval) {
//                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportToCustomPopup, sender: nil)
//                } else {
//                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportViewToWithdrawn, sender: nil)
//                }
//            }
//        }
        
        actionButton.addItem(title: "", image: UIImage(named: "cardID")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportViewToPictureId, sender: nil)
        }
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        // last 4 lines can be replaced with
        
        actionButton.overlayView.backgroundColor = .clear
        actionButton.buttonImage = UIImage(named: "more_white")
        actionButton.buttonColor = AppTheme.brandColor
        actionButton.buttonImageColor = .white
        
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 14)
        
        //        actionButton.layer.shadowColor = UIColor.black.cgColor
        //        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        //        actionButton.layer.shadowOpacity = Float(0.4)
        //        actionButton.layer.shadowRadius = CGFloat(2)
        
        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.configureDefaultItem { item in
            item.titlePosition = .leading
            
                item.titleLabel.font = UIFont.appRomanFontWith(size: 18.0)

            item.titleLabel.textColor = AppTheme.textColor
            item.buttonColor = AppTheme.brandColor
            item.buttonImageColor = .white
            
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
    }
    
    @objc func revertedStatusUpdate(notfication: NSNotification) {
        if let info = notfication.userInfo as? [String: String] {
            self.reportStatus = info["status"] ?? ""
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("revertedStatus"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.reportViewToWithdrawn  {
            NotificationCenter.default.addObserver(self, selector: #selector(revertedStatusUpdate(notfication:)), name: Notification.Name("revertedStatus"), object: nil)
            if let navVc = segue.destination as? WithDrawnViewController {
                navVc.isNavigatingFrom = MyinterviewsStatus.report
                navVc.interviewReportId = self.interviewReportId
            }
        }
        if segue.identifier == StoryboardSegueIdentifiers.reportViewToShare {
            let navVC = segue.destination as? UINavigationController
            if let shareViewController = navVC?.viewControllers.first as? ShareInterviewViewController {
                shareViewController.jobID = self.jobId
                shareViewController.currentIndex = 1
                shareViewController.inteviewStatus = .completed
                shareViewController.interviewCode = self.interviewCode
            }
        }
        if segue.identifier == StoryboardSegueIdentifiers.reportViewToPictureId {
            let navVC = segue.destination as? UINavigationController
            if let pictureIdController = navVC?.viewControllers.first as? PictureIdViewController {
                pictureIdController.imageUrl =  self.candidateCaptureImageUrl
                pictureIdController.candidateName = self.candidateFirstName
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.reportToCustomPopup {
            if let navVc = segue.destination as? NoshowReasonViewController {
                navVc.isNavigatingFrom = RevertReport.revert
                navVc.report_status = self.reportStatus
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.reportToFeedback {
            let navVC = segue.destination as? UINavigationController
            if let feedbackController = navVC?.viewControllers.first as? FeedbackViewController {
                feedbackController.interviewCode = self.interviewCode
                feedbackController.grievancePeriodValue = self.isGrievanceEnabled
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.reportToImagesView {
            let navVC = segue.destination as? UINavigationController
            if let imagesScrollableController = navVC?.viewControllers.first as? ImagesScrollableViewController {
                if let index = sender as? Int {
                    imagesScrollableController.index = index
                }
                imagesScrollableController.imagesArray = self.images
            }
        }
    }
}

/*
 This Extensions loads chart view with data, customzied with respect to the design provided.
 */

//MARK: - Setup Chart ChartViewDelegate
extension ReportViewController : ChartViewDelegate {
    
    func loadChartView() {
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleData,
                        .toggleBarBorders]
        self.setupBarChart(chartView: skillsBarchartView)
        skillsBarchartView.drawBarShadowEnabled = false
        skillsBarchartView.maxVisibleCount = 60
        //        skillsBarchartView.isHighlightFullBarEnabled  = true
        skillsBarchartView.drawValueAboveBarEnabled = true
        skillsBarchartView.delegate = self
        skillsBarchartView.legend.enabled = false
        skillsBarchartView.noDataText = "You need to provide data for the chart."
        skillsBarchartView.chartDescription?.text = ""
        let skills = ["Required skills", "Optional Skills"]
        //legend
        let legend = skillsBarchartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.yOffset = 0.0
        legend.xOffset = 0.0
        legend.yEntrySpace = 0.0
        legend.drawInside = false
        self.summaryScoreLabel.text = "Summary Score: " + summaryScore
        self.summaryScoreLabel.roman(size: 16.0)
        let xaxis = skillsBarchartView.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: skills)
        xaxis.granularity = 1

        xaxis.labelFont = UIFont.appLightFontWith(size: 16.0)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = skillsBarchartView.leftAxis
        yaxis.spaceTop = 10.0
        yaxis.axisMinimum = 0.0
        yaxis.labelCount = 5
        yaxis.granularity = 1
        yaxis.axisMaximum = 5.0
        //yaxis.drawGridLinesEnabled = true
        skillsBarchartView.rightAxis.enabled = false
        let marker:BalloonMarker = BalloonMarker(color: AppTheme.brandColor, font: UIFont.appBoldFontWith(size: 18.0), textColor: .white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        marker.minimumSize = CGSize(width: 20.0, height: 15.0)//CGSize(75.0, 35.0)
        skillsBarchartView.marker = marker
        self.updateChartData()
    }
    
    func updateChartData() {
        if self.shouldHideData {
            skillsBarchartView.data = nil
            return
        }
        self.setDataCount(20, range: UInt32(Double(5)), parties: skillsParties, ForChart: skillsBarchartView)
    }
    
    open class ChartColor: NSObject
    {
        @objc open class func required () -> [NSUIColor]
        {
            return [
                NSUIColor(red: 227/255.0, green: 175/255.0, blue: 96/255.0, alpha: 1.0),
            ]
        }
        @objc open class func optional () -> [NSUIColor]
        {
            return [
                NSUIColor(red: 235/255.0, green: 97/255.0, blue: 97/255.0, alpha: 1.0),
            ]
        }
    }
    
    func setDataCount(_ count: Int, range: UInt32, parties : [String],ForChart chartView: BarChartView) {
        let skills = ["Required Skills", "Optional Skills"]
        chartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []

        for index in 0..<skills.count {
            let dataEntry = BarChartDataEntry(x: Double(index) , y: self.viewModel.averageCompentancyScore[index])
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(index) , y:  self.viewModel.averageExperienceScore[index])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Average Competency Score")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Average Experience Score")
        
        chartDataSet.colors = ChartColor.required()
        chartDataSet1.colors = ChartColor.optional()
        
        let customFont = UIFont.appLightFontWith(size: 16.0)
        chartDataSet.valueFont = customFont
        chartDataSet1.valueFont = customFont

        chartDataSet.valueColors = [.red]
        chartDataSet1.valueColors = [.red]
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        for set in chartData.dataSets {
            set.drawValuesEnabled = !set.drawValuesEnabled
        }
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = skills.count
        let startYear = 0
        
        chartData.barWidth = barWidth

        
        
        chartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        chartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartView.notifyDataSetChanged()
        chartView.data = chartData
        chartView.backgroundColor = .white
        chartDataSet.valueFont = customFont
        chartDataSet1.valueFont = customFont

        //chart animation
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    
    /* Setup Bar chart
     Customize bar chart here
     */
    func setupBarChart(chartView: BarChartView) {
        chartView.chartDescription?.enabled = true
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
    }
    
}

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    case toggleShowCandleBar
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        case .toggleShowCandleBar: return "Toggle show candle bar"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}

// MARK: - Audio and Video list Datasource and Delegates
extension ReportViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == audioTableView || tableView == videosTableView {
            return 60
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == skillsTableView) {
            return viewModel.skillstableViewData.count
        }else if (tableView == codeTableView) {
            return viewModel.codeTableViewData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == audioTableView {
            
            return audiosArray.count
            
        } else if tableView == videosTableView {
            
            return videosArray.count
            
        } else if tableView == skillsTableView {
            
            if viewModel.skillstableViewData[section].opened {
                if viewModel.skillstableViewData[section].sectionData.isEmpty {
                    return 2
                }
                return viewModel.skillstableViewData[section].sectionData.count+1
            }
            return 1
            
        } else {
            if viewModel.codeTableViewData[section].opened {
                return viewModel.codeTableViewData[section].sectionData.count+1
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == audioTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.audiosTableViewCell, for: indexPath) as? AudioTableViewCell ?? AudioTableViewCell()
            cell.audioLabel.text = "Audio \(indexPath.row + 1)"
            cell.audioLabel.light(size: 18.0)
            return cell
        } else if tableView == videosTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.videosTableViewCell, for: indexPath) as? VideosTableViewCell ?? VideosTableViewCell()
            cell.videoLabel.text = "Video \(indexPath.row + 1)"
            cell.videoLabel.light(size: 18.0)

            return cell
        } else if tableView == skillsTableView {
            if (indexPath.row == 0) {
                let cell = skillsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.skillsHeader) as? SkillsTableViewCell
                cell?.skillsTitle.text = viewModel.skillstableViewData[indexPath.section].title
                cell?.skillsTitle.bold(size: 16.0)

                if (viewModel.skillstableViewData[indexPath.section].opened == true) {
                    cell?.sectionBorderLabel.isHidden = true
                    cell?.skillsDropdownImage.image = UIImage(named: "downArrow")
                } else {
                    cell?.sectionBorderLabel.isHidden = false
                    cell?.skillsDropdownImage.image = UIImage(named: "dropdownarrow")
                }
                return cell ?? UITableViewCell()
            } else {
                if (indexPath.row == viewModel.skillstableViewData[indexPath.section].sectionData.count+1) {
                    let cell = skillsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.skillsNoData) as? SkillsTableViewCell
                    cell?.noDataLabel.light(size: 14.0)
                    if (indexPath.section == 0) {
                        cell?.noDataLabel.text = Skills.noRequiredSkills
                    } else {
                        cell?.noDataLabel.text = Skills.noOptionalSkills
                    }
                    return cell ?? UITableViewCell()
                } else {
                    let cell = skillsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.skillsDetails) as? SkillsTableViewCell
                    cell?.skillsDetailsView.layer.borderWidth = 1
                    cell?.skillsDetailsView.layer.cornerRadius = 5
                    cell?.skillsDetailsView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
                    let dataArray = viewModel.skillstableViewData[indexPath.section].sectionData[indexPath.row-1]
                    cell?.skillNameLabel.text = dataArray["skill"] as? String ?? None
                    cell?.skillNameLabel.bold(size: 16.0)

                    if let assesment = dataArray["skill_assessment"] as? String {
                        cell?.automationLabel.text = assesment
                    } else {
                        cell?.automationLabel.text = "SKILL_ASSESMENT_DESC".localized
                    }

                    cell?.automationLabel.light(size: 14.0)
                    cell?.experienceLabel.roman(size: 11.0)
                    cell?.competancyLabel.roman(size: 11.0)


                    if let experienceScore = dataArray["experience_score"] as? String {
                        let rating1 = experienceScore.components(separatedBy: " - ")
                        cell?.experienceRatingView.rating = Double(rating1[0]) ?? 0.0
                        cell?.experienceRatingView.text = "\(rating1[0])"
                        cell?.experienceLabel.text = "(\(rating1[1]))"
                        cell?.experienceRatingView.didTouchCosmos = didTouchCosmos
                        
                        
                    } else {
                        cell?.experienceRatingView.rating =  0.0
                        cell?.experienceRatingView.text = "\(0)"
                        cell?.experienceLabel.text = "(-)"
                        cell?.experienceRatingView.didTouchCosmos = didTouchCosmos
                    }
                    if let preferredScore = dataArray["skill_rating"] as? String {
                        let rating2 = preferredScore.components(separatedBy: " - ")
                        cell?.competancyRatingView.rating = Double(rating2[0]) ?? 0.0
                        cell?.competancyRatingView.text = "\(rating2[0])"
                        cell?.competancyRatingView.didTouchCosmos = didtouchCompetencyStars
                        //Enhancement : 20471
                        //cell?.competancyLabel.text = "(\(rating2[1]))"
                        self.updateLabelText(rating: Double(rating2[0]) ?? 0.0, competancyLabel: cell?.competancyLabel ?? UILabel())
                    } else {
                        cell?.competancyRatingView.rating =  0.0
                        cell?.competancyRatingView.text = "\(0)"
                        cell?.competancyLabel.text = "(-)"
                        cell?.competancyRatingView.didTouchCosmos = didtouchCompetencyStars
                    }
                    
                    if (viewModel.skillstableViewData[viewModel.skillstableViewData.count-1].sectionData.count == indexPath.row && indexPath.section == viewModel.skillstableViewData.count-1) {
                        cell?.cellBorderLabel.isHidden = false
                    } else {
                        cell?.cellBorderLabel.isHidden = true
                    }
                    return cell ?? UITableViewCell()
                }
            }
            
        } else {
            if (indexPath.row == 0) {
                
                let cell = codeTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.codeHeader) as? CodeTableViewCell
                
                cell?.codeTitle.text = viewModel.codeTableViewData[indexPath.section].title

                cell?.codeTitle.bold(size: 16.0)
                
                
                if viewModel.codeTableViewData[indexPath.section].opened {
                    cell?.headerBottomBorder.isHidden = true
                    cell?.codeDropdownImage.image = UIImage(named: "downArrow")
                } else {
                    cell?.headerBottomBorder.isHidden = false
                    cell?.codeDropdownImage.image = UIImage(named: "dropdownarrow")
                }
                
                
                return cell ?? UITableViewCell()
            } else {
                let cell = codeTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.codeData) as? CodeTableViewCell
                
                let response = viewModel.codeTableViewData[indexPath.section].sectionData[indexPath.row-1]
                
                print(response)
                
                cell?.codeLabel.text = response
                cell?.codeLabel.light(size: 18.0)
                
                
                return cell ?? UITableViewCell()
            }
        }
        
    }
    

    
    private func didtouchCompetencyStars(_ rating: Double){
              switch rating {
              case 5.0:
                  showBanner(title: "Master Performer", withMessage: "Could mentor or teach others in this competency.", style: .danger)
                  case 4.0:
                    showBanner(title: "Superior Performer", withMessage: "Above-average ability is apparent in this competency.", style: .warning)
                  case 3.0:
                      showBanner(title: "Competent Performer", withMessage: "This competency requires no additional training at this time.", style: .warning)
                  case 2.0:
                      showBanner(title: "Coachable Performer", withMessage: "Some training would be required to bring competency up to standards.", style: .warning)
                  case 1.0:
                    showBanner(title: "Unacceptable Performer", withMessage: "Current competency needs substantial development. Experience Score", style: .success)
              default:
                  print("error")
              }
    }
    
    
    private func didTouchCosmos(_ rating: Double) {
        
               switch rating {
               case 5.0:
                   showBanner(title: "Extensive Experience", withMessage: "Works independently without supervision.", style: .danger)
                   case 4.0:
                       showBanner(title: "Considerable Experience", withMessage: "Performs job completely needing only minimal supervision.", style: .warning)
                   case 3.0:
                       showBanner(title: "Moderate Experience", withMessage: "Completes assignments with reasonable supervision.", style: .warning)
                   case 2.0:
                       showBanner(title: "Limited Experience", withMessage: "Handles tasks under close supervision.", style: .warning)
                   case 1.0:
                       showBanner(title: "No Experience", withMessage: "Self-reported no experience or unable to demonstrate actual experience.", style: .warning)
               default:
                   print("error")
               }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == audioTableView {
            
            let urlString = self.audiosArray[indexPath.row]
            //let urlString = "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3"
            if let videoURL = URL(string: urlString) {
                let player = AVPlayer(url: videoURL)
                
                let session = AVAudioSession.sharedInstance()
                
                do {
                    try session.setCategory(.playback, options: [])
                } catch let sessionError {
                    print("=====sessionError========")
                    print(sessionError)
                }
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        } else if(tableView == videosTableView) {
            
            let urlString = self.videosArray[indexPath.row]
            // let urlString = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
            if let videoURL = URL(string: urlString) {
                let player = AVPlayer(url: videoURL)
                
                let session = AVAudioSession.sharedInstance()
                
                do {
                    try session.setCategory(.playback, options: [])
                } catch let sessionError {
                    print("=====sessionError========")
                    print(sessionError)
                }
                
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
            }
        } else if(tableView == skillsTableView) {
            if(indexPath.row == 0) {
                if(viewModel.skillstableViewData[indexPath.section].opened == true) {
                    viewModel.skillstableViewData[indexPath.section].opened = false
                    skillsTableView.reloadData()
                } else {
                    viewModel.skillstableViewData[indexPath.section].opened = true
                    skillsTableView.reloadData()
                }
            }
        } else {
            if(indexPath.row == 0) {
                if(viewModel.codeTableViewData[indexPath.section].opened == true) {
                    viewModel.codeTableViewData[indexPath.section].opened = false
                    codeTableView.reloadData()
                } else {
                    viewModel.codeTableViewData[indexPath.section].opened = true
                    codeTableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: Collectionview to load white board images
extension ReportViewController : UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.reportViewImagesCell, for: indexPath) as? ImagesCollectionViewCell ?? ImagesCollectionViewCell()
        cell.imagesContentView.layer.borderWidth = 1
        cell.imagesContentView.layer.borderColor =  AppTheme.containerBorderColor.cgColor
        cell.imagesContentView.layer.cornerRadius = 3
        
        let imageUrl = self.images[indexPath.row]
        
        cell.imagesView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo_placeholder"))
        cell.imagesView.layer.cornerRadius = (cell.imagesView.frame.size.width)/2
        cell.imagesView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.reportStackView.frame.size.width)
        let cellWidth : CGFloat = (self.reportStackView.frame.size.width-24) / 2.0
        let cellSize = CGSize(width: cellWidth , height:cellWidth)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "reportViewToImagesScroll", sender: indexPath.row)
    }
    
}

extension ReportViewController {
    
    func updateLabelText(rating : Double,competancyLabel : UILabel) {

        switch rating {
        case 1.0:
            competancyLabel.text = "(Unacceptable Performer)"
        case 2.0:
            competancyLabel.text = "(Coachable Performer)"
            
        case 3.0:
            competancyLabel.text = "(Competent Performer)"
            
        case 4.0:
            competancyLabel.text = "(Superior Performer)"
            
        case 5.0:
            competancyLabel.text = "(Master Performer)"
        default:
            competancyLabel.text = "(-)"
        }
        
    }
}

extension ReportViewController {
    func setupView() {
        summaryScoreLabel.bold(size: 18.0)
        summaryTextView.light(size: 16.0)
        summaryHeader.bold(size: 16.0)
        noAuidosLabel.light(size: 18.0)
        noVideosLabel.light(size: 18.0)
        noCodeData.light(size: 18.0)
        noImagesToShow.light(size: 18.0)
    }
}
