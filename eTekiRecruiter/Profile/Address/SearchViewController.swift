//
//  SearchViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 16/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var createJobAPI: CreateJobAPIProtocol.Type = CreateJobAPI.self
    var candidateAPI : CandidatesAPIProtocol.Type =  CandidatesAPI.self
    var candiateOwners = [Dictionary<String,Any>]()
    var ownerID = ""
    var ownerName = ""
    
    var currentSearch : String?
    var selectedItem = ""
    var selectedString = ""
    var areasExpertise = [String]()
    var countiresList = [String]()
    var ownersList = [String]()
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var currentPage = 0
    var totalCandidatesCount = 0
    var candidatesArray = [Dictionary<String,Any>]()
    var filterKey = ""
    var jobID = ""
    var jobStatus = ""
    var jobClosingDate = ""
    var searchKey = ""
    var searchText = ""
    
    
    var searchTimeZoneData =  ["(GMT11:00) American Samoa, Midway Island","(GMT10:00) Hawaii","(GMT09:00) Alaska","(GMT08:00) Pacific Time (US & Canada)","(GMT07:00) Arizona, Mountain Time (US & Canada)","(GMT06:00) Central Time (US & Canada), Mexico City","(GMT05:00) Eastern Time (US & Canada), US/Michigan","(GMT04:00) Atlantic Time (Canada), Santiago","(GMT03:30) Newfoundland","(GMT03:00) Brasilia, Greenland","(GMT02:00) MidAtlantic","(GMT+01:00) Amsterdam, Berlin, Copenhagen, Paris",
                               "(GMT+02:00) Athens, Harare, Jerusalem",
                               "(GMT+03:00) Kuwait",
                               "(GMT+04:00) Abu Dhabi, Moscow",
                               "(GMT+05:00) Karachi, Islamabad, Tashkent",
                               "(GMT+05:30) Chennai, Mumbai, Kolkata",
                               "(GMT+06:00) Dhaka, Ekaterinburg",
                               "(GMT+07:00) Bangkok, Jakarta",
                               "(GMT+08:00) Beijing, Hong Kong, Singapore",
                               "(GMT+09:00) Seoul, Tokyo",
                               "(GMT+10:00) Melbourne",
                               "(GMT+11:00) New Caledonia, Vladivostok",
                               "(GMT+12:00) Auckland, Wellington, Magadan"]
    
    var menuList = Array<String>()
    var candidateList =  Array<Dictionary<String,Any>>()
    
    var selectedKey = ""
    var selectedValue = ""
    var selectedCandidate : Dictionary<String,Any>?
    var selectDictionary : Dictionary<String,String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataLabel.isHidden = true
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
        
        if currentSearch == StoryboardSegueIdentifiers.addCandidateToCandidateOwner {
            
            self.showSpinner()
            self.getOwners()
            searchBar.placeholder = "Candidate Owner's"
            
        } else if currentSearch == StoryboardSegueIdentifiers.createJobToLangaugeSearch {
            
            let languages = self.languages()
            menuList = languages
            searchBar.placeholder = "Languages"
            
        } else if currentSearch == StoryboardSegueIdentifiers.createJobToAreaExpertise {
            self.searchBar.placeholder = "Area of Expertise"
            self.showSpinner()
            self.createJobAPI.getAreaOfExpertises { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    DispatchQueue.main.async {
                        if let categories = response?.categories {
                            print(categories)
                            self.menuList = categories
                            self.areasExpertise = categories
                            self.searchTableView.reloadData()
                        }
                        self.removeSpinner()
                    }
                }
            }
            
            
        } else if currentSearch == StoryboardSegueIdentifiers.createJobToCountrySearch {
            
            self.searchBar.placeholder = "Search"
            self.showSpinner()
            
            self.searchAPI.getCountries() { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    DispatchQueue.main.async {
                        if let countries = response?["countries"] as? [String] {
                            print(countries)
                            self.menuList = countries
                            self.countiresList = countries
                            self.searchTableView.reloadData()
                        }
                        self.removeSpinner()
                    }
                }
            }
            
        }  else if currentSearch == "StateToSearch" {
            
            menuList =  LocalCountry.usstates
            searchBar.placeholder = "Select States"
            
        } else if currentSearch == "SearchTimeZones" {
            self.callTimeZoneAPI()
        }  else if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            self.searchBar.placeholder = "Select candidates"
            self.loadCandidates()
        } else {
            self.callTimeZoneAPI()
        }

        self.searchBar.change(textFont: UIFont.appLightFontWith(size: 18.0))
        self.searchBar.setText(color: AppTheme.textColor)
        self.searchBar.setPlaceholderText(color: AppTheme.placeHolderColor)        
    }
    
    func callTimeZoneAPI() {
        self.showSpinner()
        self.searchAPI.getTimeZones { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                guard let timezoneResponse = response else {
                    self.removeSpinner()
                    return
                }
                
                if let timeZones = timezoneResponse["time_zones"] as? Array<Dictionary<String,String>> {
                    LocalCountry.timezoneList = timeZones
                    
                    for dict in LocalCountry.timezoneList {
                        for (key,value) in dict {
                            self.menuList.append(value)
                            print(key)
                        }
                    }
                    self.searchTimeZoneData = self.menuList
                    DispatchQueue.main.async {
                        print(self.menuList)
                        self.removeSpinner()
                        self.searchTableView.reloadData()
                    }
                    
                } else {
                    self.removeSpinner()
                    self.showBanner(title: "", withMessage: "Unable to fetch timezones", style: .danger)
                }
            }
        }
        searchBar.placeholder = "Select Time Zone"
    }
    
    
    func languages() -> [String] {
        
        var languages = [String]()
        languages = ["Mandarin", "Spanish", "English", "Hindi / Urdu", "Arabic", "Portuguese", "Bengali", "Russian", "Japanese", "Punjabi", "German", "Javanese", "Wu", "Malay/Indonesian", "Telugu", "Vietnamese", "Korean", "French", "Marathi", "Tamil", "Persian", "Turkish", "Italian", "Cantonese", "Thai", "Gujarati", "Jin", "Min Nan", "Polish", "Pashto", "Kannada", "Xiang", "Malayalam", "Sundanese", "Hausa", "Oriya", "Burmese", "Hakka", "Ukrainian", "Bhojpuri", "Tagalog", "Yoruba", "Maithili", "Swahili", "Uzbek", "Sindhi", "Amharic", "Fula", "Romanian", "Oromo", "Igbo", "Azerbaijani", "Awadhi", "Gan", "Cebuano", "Dutch", "Kurdish", "Serbo-Croatian", "Malagasy", "Saraiki", "Nepali", "Sinhalese", "Chittagonian", "Khmer", "Assamese", "Madurese", "Somali", "Marwari", "Magahi", "Haryanvi", "Hungarian", "Chhattisgarhi", "Greek", "Chewa", "Deccan", "Akan", "Kazakh", "Min Bei", "Sylheti", "Zulu", "Czech", "Kinyarwanda", "Dhundhari", "Haitian Creole", "Min Dong", "Ilokano", "Quechua", "Kirundi", "Swedish", "Hmong", "Shona", "Uyghur", "Hiligaynon", "Mossi", "Xhosa", "Belarusian", "Balochi", "Konkani"]
        return languages.sorted()
        
    }
    
    
    func doneAction() {
        
        if currentSearch == StoryboardSegueIdentifiers.createJobToAreaExpertise {
            
            if selectedString != "" {
                NotificationCenter.default.post(name: Notification.Name("AreasExpertise"), object: nil, userInfo: ["selectedArea":selectedString])
            }
            
        } else if currentSearch == StoryboardSegueIdentifiers.createJobToLangaugeSearch {
            if selectedString != "" {
                NotificationCenter.default.post(name: Notification.Name("LanguageSearch"), object: nil, userInfo: ["selectedLangauge":selectedString])
            }
            
        }  else if currentSearch == StoryboardSegueIdentifiers.createJobToCountrySearch {
            if selectedString != "" {
                NotificationCenter.default.post(name: Notification.Name("CountriesSearch"), object: nil, userInfo: ["selectedCountry":selectedString])
            }
            
        } else if currentSearch == "StateToSearch" {
            
            if selectedString != "" {
                NotificationCenter.default.post(name: Notification.Name("StateSearch"), object: nil, userInfo: ["selectedState":selectedString])
            }
            
        } else if currentSearch == "SearchTimeZones" {
            
            if selectDictionary != nil {
                NotificationCenter.default.post(name: Notification.Name("SearchTimeZones"), object: nil, userInfo: ["timezone":selectDictionary ?? ["":""]])
            }
        }  else if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            
            if selectedCandidate != nil {
                NotificationCenter.default.post(name: Notification.Name(StoryboardSegueIdentifiers.candidateToSearch), object: nil, userInfo: ["selectedCandidate":selectedCandidate ?? ["":""]])
            }
        } else if currentSearch == StoryboardSegueIdentifiers.addCandidateToCandidateOwner {
            
            if selectDictionary != nil {
                NotificationCenter.default.post(name: Notification.Name("GET_OWNERS"), object: nil, userInfo: ["owners":selectDictionary ?? ["":""]])
            }
        }
        
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            return candidateList.count
        }
        
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchTableViewCell, for: indexPath) as! SearchCell
        cell.selectionStyle = .default
        
        if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            
            let candidate = self.candidateList[indexPath.row]
            
            if let candidateName = candidate["full_name"] as? String {
                cell.searchLabel.text = candidateName
            }
            
        } else {
            cell.searchLabel.text = menuList[indexPath.row]
        }
        
        if cell.searchLabel.text == self.selectedItem {
            cell.backgroundColor = AppTheme.brandColor
        } else {
            cell.backgroundColor = AppTheme.appBackgroundColor
        }

        cell.searchLabel.light(size: 18.0)
        cell.searchLabel.textColor =  AppTheme.textColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        
        let searchText = cell.searchLabel.text ?? ""
        if currentSearch == "SearchTimeZones" {
            
            self.sortTimeZones(searchText: searchText)
            
        } else if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            
            let candidate = self.candidateList[indexPath.row]
            selectedCandidate = candidate
            
        } else if currentSearch == StoryboardSegueIdentifiers.addCandidateToCandidateOwner {
            
            selectedString = searchText
            for recruiter in self.candiateOwners {
                guard let name  = recruiter["full_name"] as? String else {return}
                guard let ownerID  = recruiter["id"] as? Int else {return}
                if name == selectedString {
                    self.ownerID = "\(ownerID)"
                    selectDictionary = [self.ownerID : name]
                }
            }
            
            
        } else {
            selectedString = searchText
        }
        
        self.doneAction()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentSearch == StoryboardSegueIdentifiers.createJobToAreaExpertise {
            return 60
        }
        return 50
    }
    
    func sortTimeZones(searchText : String) {
        for dict in LocalCountry.timezoneList {
            for (key,value) in dict {
                if value == searchText {
                    selectDictionary = [key:value]
                }
            }
        }
    }
    
    //MARK: SEARCH FUNCTIONALITY
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var tempArray = [String]()
        
        if currentSearch == StoryboardSegueIdentifiers.createJobToAreaExpertise {
            
            tempArray = areasExpertise
            
        } else  if currentSearch == StoryboardSegueIdentifiers.createJobToLangaugeSearch {
            
            let langauges = self.languages()
            tempArray = langauges
            
            
        } else  if currentSearch == StoryboardSegueIdentifiers.createJobToCountrySearch {
            
            tempArray = countiresList
            
            
        } else if currentSearch == "StateToSearch" {
            
            tempArray = LocalCountry.usstates
            
        }  else if currentSearch == "SearchTimeZones" {
            
            tempArray = searchTimeZoneData
            self.noDataLabel.text = "No Time Zones on this search."
            
            
        } else if currentSearch == StoryboardSegueIdentifiers.candidateToSearch {
            
            self.searchText = searchText
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 2.0)
            
            
        } else if currentSearch == StoryboardSegueIdentifiers.addCandidateToCandidateOwner {
            
            tempArray = ownersList
            self.noDataLabel.text = "No recruiters to show."
            
        }
        
        menuList = searchText.isEmpty ? tempArray : tempArray.filter({(dataString: String) -> Bool in
            
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        DispatchQueue.main.async {
            if self.menuList.count == 0 {
                self.noDataLabel.isHidden = false
                self.searchTableView.isHidden = true
            } else {
                self.noDataLabel.isHidden = true
                self.searchTableView.isHidden = false
            }
        }
        searchTableView.reloadData()
    }
    
    
}

//MARK: LOAD CANDIDATES
extension SearchViewController {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func reload() {
        self.currentPage = 0
        self.loadCandidates()
    }
    
    func loadCandidates() {
        self.showSpinner()
        currentPage = currentPage+1
        
        
        self.candidatesAPI.getCandidates(manager: CandidatesManager(jobID: jobID, status: .all,page: "\(currentPage)",perPage: "\(10)",searchKeyWord: searchText,statusKey: "status")) { (response, error) in
            
            let success = response?["success"] as? Bool ?? false
            
            if success {
                
                self.totalCandidatesCount = response?["total_count"] as? Int ?? 0
                if let candidates = response?["candidates"] as? [Dictionary<String,Any>] {
                    
                    if self.candidateList.count > 0 {
                        self.candidateList.removeAll()
                    }
                    
                    DispatchQueue.main.async {
                        if candidates.count > 0 {
                            self.candidatesArray = candidates
                            for i in 0..<self.candidatesArray.count {
                                let candidate = self.candidatesArray[i]
                                if let status = candidate["status"] as? String  {
                                    if status != .withdrawn && status != .completed {
                                        self.candidateList.append(candidate)
                                    }
                                }
                            }
                            
                            if self.candidateList.count > 0 {
                                self.containerView.isHidden = false
                                self.noDataView.isHidden = true
                            } else {
                                self.containerView.isHidden = true
                                self.noDataView.isHidden = false
                            }
                            self.searchTableView.reloadData()
                        } else {
                            self.containerView.isHidden = true
                            self.noDataView.isHidden = false
                            self.showBanner(title: "", withMessage: "No candidates To show", style: .danger)
                        }
                        self.removeSpinner()
                    }
                }
            } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
}

//MARK: SEARCH CANDIDATE OWNERS
extension SearchViewController {
    
    func getOwners() {
        
        self.candidateAPI.getOwners(candidatesManager: CandidatesManager(jobID: jobID)) { (response, errorResponse) in
            
            if errorResponse != nil {
                
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
                
            } else {
                
                DispatchQueue.main.async {
                    if let recruiters = response?["recruiters"] as? [Dictionary<String,Any>] {
                        self.candiateOwners = recruiters
                        
                        print(self.ownerID)
                        print(self.candiateOwners)
                        
                        for recruiter in self.candiateOwners {
                            guard let name  = recruiter["full_name"] as? String else {return}
                            self.menuList.append(name)
                            self.ownersList.append(name)
                            guard let ownerID  = recruiter["id"] as? Int else {return}
                            if name == self.ownerName {
                                self.ownerID = "\(ownerID)"
                            }
                        }
                        self.searchTableView.reloadData()
                    }
                    self.removeSpinner()
                }
            }
        }
    }
    
}
