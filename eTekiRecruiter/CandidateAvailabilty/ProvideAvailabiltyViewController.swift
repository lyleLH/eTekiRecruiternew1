//
//  ProvideAvailabiltyViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 19/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ProvideAvailabiltyViewController: BaseViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timezoneTextField: PaddingTextField!
    @IBOutlet weak var selectedCandidate: PaddingTextField!
    @IBOutlet weak var feedbackDueDate: PaddingTextField!
    @IBOutlet weak var calendarWeekView: LongPressWeekView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var timeZoneDrodownButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = AllDayViewModel()
    var isNavigatingFrom = ""
    var selectedDate = Date()
    var dueDate = Date()
    
    @IBOutlet weak var candidateDropImage: UIImageView!
    @IBOutlet weak var candidateView: UIView!
    @IBOutlet weak var candidateButton: UIButton!
    
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var currentPage = 0
    var totalCandidatesCount = 0
    var candidatesArray = [Dictionary<String,Any>]()
    var responseArray = [Dictionary<String,Any>]()
    @IBOutlet weak var anchorView: UILabel!
    @IBOutlet weak var noteLabel: PaddingLabel!
    var jobID = ""
    var candidateID = ""
    var prefferedInterViewTime = ""
    var timeSlots = [String]()
    var jobStatus = ""
    var selectedTimeZoneCode = ""
    let dateFormatter = DateFormatter()
    let dueDatePicker = UIDatePicker()
    var currentTimeZone = TimeZone.current
    var jobClosedDate = ""
    var feedBackDueDate = ""
    var isCandidatesAvailable = false
    @IBAction func showPicker(_ sender: Any) {
        self.showPicker()
    }
    
    @IBAction func submitAvailableSlots(_ sender: Any) {
        
        if timeSlots.count == 0 {
            self.showBanner(title: "", withMessage: "Time slots can't be blank", style: .warning)
            return
        }
        
        if timeSlots.count > 2 {
            self.showSpinner()
            
            
            print("======================Time slots=======================")
            print(self.timeSlots)
            
            self.updateCandidateAvailibity(candidateManager: CandidatesManager(jobID: self.jobID, candidateId: self.candidateID, currentTimeZone: self.selectedTimeZoneCode, prefferedInterViewTime: self.prefferedInterViewTime, timeSlots: self.timeSlots))
            
        } else {
            self.showBanner(title: "", withMessage: "Please provide at least 3 time slots.", style: .warning)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}


extension ProvideAvailabiltyViewController {
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == StoryboardSegueIdentifiers.candidateToSearch {
            
            if isNavigatingFrom == StoryboardSegueIdentifiers.moreToCandidateAvailabilty {
                return true
            }
            
            if !isCandidatesAvailable {
                self.showBanner(title: "", withMessage: "NO_CANDIDATES_TO_SHOW".localized, style: .warning)
            }
            return isCandidatesAvailable
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegueIdentifiers.provideAvailabiltyToTimeZones {
            let navVC = segue.destination as? UINavigationController
            let searchVc = navVC?.viewControllers.first as? SearchViewController
            NotificationCenter.default.addObserver(self, selector: #selector(updateTimeZone(notfication:)), name: Notification.Name("SearchTimeZones"), object: nil)
            searchVc?.currentSearch = "SearchTimeZones"
            searchVc?.selectedItem = self.timezoneTextField.text ?? ""
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.candidateToSearch {
            let navVC = segue.destination as? UINavigationController
            let searchVc = navVC?.viewControllers.first as? SearchViewController
            searchVc?.jobID = jobID
            NotificationCenter.default.addObserver(self, selector: #selector(candidateDetails(notfication:)), name: Notification.Name(StoryboardSegueIdentifiers.candidateToSearch), object: nil)
            searchVc?.currentSearch = StoryboardSegueIdentifiers.candidateToSearch
            searchVc?.selectedItem = self.selectedCandidate.text ?? ""
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage {
            if let navVC = segue.destination as? CustomAlertViewController {
                let parameters: [String: Date] = ["selectedEvent" : selectedDate]
                // print(currentAnalyticStatus)
                navVC.isNavigatingFrom = StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage
                navVC.infoData = parameters
                NotificationCenter.default.addObserver(self, selector: #selector(removeSlotConfirmAction(notfication:)), name: Notification.Name(StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage), object: nil)
            }
        }
    }
    
    @objc func removeSlot(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            
            if let event = info["selectedEvent"] as? AllDayEvent {
                print("===========================================")
                print(event.startDate)
                selectedDate = event.startDate
                self.performSegue(withIdentifier: StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage, sender: self)
                
            }
        }
        
    }
    
    @objc func removeSlotConfirmAction(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let selectedEvent = info["selectedEvent"] as? Date {
                
                print(selectedEvent)
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
                let timeSlot = dateformatter.string(from: selectedEvent)
                //let utcSlot = self.localToUTC(date: timeSlot)
                let utcSlot = self.localToUTC(date: timeSlot,withTimeZone: self.currentTimeZone)
                
                
                for event in self.viewModel.events {
                    
                    let eventStartDate = dateformatter.string(from: event.startDate)
                    if timeSlot == eventStartDate {
                        self.viewModel.events.remove(object: event)
                        self.viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
                        calendarWeekView.forceReload(reloadEvents: viewModel.eventsByDate)
                        
                        if self.timeSlots.contains(obj: utcSlot) {
                            print("===============Slot Removed================")
                            print(utcSlot)
                            print(timeSlot)
                            self.timeSlots.remove(object: utcSlot)
                        }
                    }
                    
                }
            }
            NotificationCenter.default.removeObserver(self, name: Notification.Name(StoryboardSegueIdentifiers.analyticsToCustomMessage), object: nil)
        }
    }
    
    @objc func updateTimeZone(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? [String : Any] {
            // Check if value present before using it
            if let searchData = info["timezone"] as? [String : String] {

                for (key,value) in searchData {
                    self.timezoneTextField.text = value
                    self.selectedTimeZoneCode = key
                    print(selectedTimeZoneCode)
                    self.currentTimeZone = TimeZone(identifier: selectedTimeZoneCode) ?? TimeZone.current
                    self.updateFeedBackDate()
                    self.viewModel.events.removeAll()
                    for index in 0..<timeSlots.count {
                        let startTime = timeSlots[index]
                        
                        let localStartTime = self.convertUTCToLocalTimeZone(date: startTime, withTimeZone: self.currentTimeZone)
                        
                        let formatedStartDate = localStartTime.toDateGeneric()
                        let event = AllDayEvent(id: UUID().uuidString, title: "", startDate: formatedStartDate, endDate: formatedStartDate.add(component: .hour, value: 1), location: "", isAllDay: false)
                        self.viewModel.events.append(event)
                    }
                    self.updateDateAndTime()
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SearchTimeZones"), object: nil)
        
    }
    
    func updateFeedBackDate() {
        
        print(self.currentTimeZone)
        let localDate = self.convertUTCToLocalTimeZone(date: self.prefferedInterViewTime,withTimeZone: self.currentTimeZone)
        self.feedbackDueDate.text = localDate
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        guard let formattedDueDate = dateformatter.date(from: localDate) else {return}
        self.dueDatePicker.date = formattedDueDate
        if formattedDueDate < Date() {
            self.showBanner(title: "", withMessage: "Candidate report due date expired. To provide availability update the candidate report due date.", style: .warning)
            self.errorLabel.text = "Candidate report due date expired. To provide availability update the candidate report due date."
        }else{
            self.errorLabel.text = ""
        }
    }
    
    func updateFeedBackDate(_ timezone : TimeZone) {
        
        let localDate = self.convertUTCToLocalTimeZone(date: self.prefferedInterViewTime,withTimeZone: timezone)
        self.feedbackDueDate.text = localDate
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        guard let formattedDueDate = dateformatter.date(from: localDate) else {return}
        self.dueDatePicker.date = formattedDueDate
        if formattedDueDate < Date() {
            self.showBanner(title: "", withMessage: "Candidate report due date expired. To provide availability update the candidate report due date.", style: .warning)
                self.errorLabel.text = "Candidate report due date expired. To provide availability update the candidate report due date."
            }else{
                self.errorLabel.text = ""
            }
    }
    
    func updateDateAndTime(){
        for i in 0..<viewModel.events.count {
            
            var calendar = Calendar.current
            calendar.timeZone = self.currentTimeZone
            let dateFormatter = DateFormatter()
            let components = calendar.dateComponents([.year , .month, .day, .hour, .minute, .second], from: viewModel.events[i].startDate)
            let components1 = calendar.dateComponents([.year , .month, .day, .hour, .minute, .second], from: viewModel.events[i].endDate)
            guard let startTime = DateComponents(calendar: Calendar.current, timeZone: self.currentTimeZone, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second).date else {return}
            guard let endTime = DateComponents(calendar: Calendar.current, timeZone: self.currentTimeZone, year: components1.year, month: components1.month, day: components1.day, hour: components1.hour, minute: components1.minute, second: components1.second).date else {return}
            
            viewModel.events[i].startDate =   startTime
            viewModel.events[i].endDate = endTime
            
            dateFormatter.dateFormat = "hh:mm"
            viewModel.events[i].title = "\(dateFormatter.string(from:  startTime)) \n - \n\(dateFormatter.string(from:  endTime))"
            print(viewModel.events[i].startDate)
        }
        
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        calendarWeekView.forceReload(reloadEvents: viewModel.eventsByDate)
    }
    
    @objc func candidateDetails(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let candidate = info["selectedCandidate"] as? Dictionary<String,Any> {
                if let candidateID = candidate["id"] as? Int {
                    self.candidateID = "\(candidateID)"
                    self.showSpinner()
                    self.getCandidateAvailabilty(candidateID: "\(candidateID)")
                }
                
                if let fullName = candidate["full_name"] as? String {
                    self.selectedCandidate.text = fullName
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name(StoryboardSegueIdentifiers.candidateToSearch), object: nil)
    }
    
    func getCandidateAvailabilty(candidateID : String) {
        // candidates/<<candidate_id>>/candidate_availabilities
        
        candidatesAPI.getCandidateAvailability(candidatesManager: CandidatesManager(candidateID: candidateID)) { (response, errorResponse) in
            
            
            if let candidateDetails = response?["candidate"] as? Dictionary<String,Any> {
                
                DispatchQueue.main.async {
                    self.selectedCandidate.text = candidateDetails["full_name"] as? String ?? ""
                    
                    //
                    
              
                    
                    if let candidateTimeZone = candidateDetails["time_zone"] as? String {
                        
                        for dict in LocalCountry.timezoneList {
                            for (key,value) in dict {
                                
                                if key == candidateTimeZone {
                                    self.timezoneTextField.text = value
                                    self.selectedTimeZoneCode = key
                                    self.currentTimeZone = TimeZone(identifier: key) ?? TimeZone.current
                                }
                            }
                        }
                    }
                    
                    if let reportDueBy = candidateDetails["feedback_due_by"]  as? String {
                                      self.prefferedInterViewTime = reportDueBy
                                      self.updateFeedBackDate()
                    }
                    
                    if let candidateAvailabilities = candidateDetails["time_slots"] as? [String] {
                        
                        self.viewModel.events.removeAll()
                        self.timeSlots.removeAll()
                        
                        for i in 0..<candidateAvailabilities.count {
                            let startTime = candidateAvailabilities[i]
                            self.timeSlots.append(startTime)
                            let localStartTime = self.convertUTCToLocalTimeZone(date: startTime,withTimeZone: self.currentTimeZone)
                            let formatedStartDate = localStartTime.toDateGeneric()
                            let event = AllDayEvent(id: UUID().uuidString, title: "", startDate: formatedStartDate, endDate: formatedStartDate.add(component: .hour, value: 1), location: "", isAllDay: false)
                            self.viewModel.events.append(event)
                        }
                        
                        self.updateDateAndTime()
                    }
                    
                    if let jobDueDate = candidateDetails["job_due_at"] as? String {
                        self.jobClosedDate = jobDueDate
                    }
                    self.removeSpinner()
                    
                }
            }
        }
    }
    
    func updateCandidateAvailibity(candidateManager : CandidatesManager?) {
        // candidates/<<candidate_id>>/candidate_availabilities
        candidatesAPI.updateCandidateAvailability(candidateManager: candidateManager) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                DispatchQueue.main.async {
                    guard let jsonResponse =  response else {return}
                    let successMessage = jsonResponse["message"] as? [String] ?? ["Success"]
                    self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                    self.removeSpinner()
                }
            }
        }
    }
}

extension ProvideAvailabiltyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteLabel.roman(size: 11.0)
        self.noteLabel.textColor = AppTheme.textColor
        if isNavigatingFrom == StoryboardSegueIdentifiers.moreToCandidateAvailabilty {
            self.showSpinner()
            self.getCandidateAvailabilty(candidateID: self.candidateID)
            self.submitButton.setTitle(.update, for: .normal)
            self.candidateView.isUserInteractionEnabled = false
            self.candidateView.alpha = 0.5
        } else {
            self.loadCandidates()
        }
        self.setUpNavigationBar()
        setupBasic()
        setupCalendarView()
        NotificationCenter.default.addObserver(self, selector: #selector(removeSlot(notfication:)), name: Notification.Name("RemoveTimeSlot"), object: nil)
        self.submitButton.bold(size: 18.0)

    }

    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }
    
    private func setupCalendarView() {
        calendarWeekView.baseDelegate = self
        
        calendarWeekView.setupCalendar(numOfDays: 5,
                                       setDate: Date(),
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: .pageScroll,
                                       scrollableRange: (nil, nil))
        
        calendarWeekView.longPressDelegate = self
        calendarWeekView.longPressDataSource = self
        calendarWeekView.longPressTypes = [.addNew, .move]
        calendarWeekView.addNewDurationMins = 60
        calendarWeekView.moveTimeMinInterval = 30
        calendarWeekView.longPressTimeLabel.bold(size: 16)
    }    
    
}

extension ProvideAvailabiltyViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        //updateNaviBarTitle()
    }
}

// LongPress core
extension ProvideAvailabiltyViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
    
    func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        var cal = Calendar.current
        cal.timeZone = self.currentTimeZone
        let newEvent = AllDayEvent(id: UUID().uuidString, title: "\(dateFormatter.string(from: startDate)) \n - \n \(dateFormatter.string(from: startDate.add(component: .hour, value: 1)))", startDate: startDate, endDate: startDate.add(component: .hour, value: 1),
                                   location: "", isAllDay: false)
        
        if viewModel.eventsByDate[startDate.startOfDay] == nil {
            viewModel.eventsByDate[startDate.startOfDay] = [AllDayEvent]()
        }
        let due_date =  Calendar.current.date(byAdding: .hour, value: -5, to: dueDatePicker.date)!
        dateFormatter.dateFormat =  "dd-MMMM-yyyy hh:mm a"
        let dueDate_string = dateFormatter.string(from: Calendar.current.date(byAdding: .minute, value: -30, to: due_date)!)
        
        if(newEvent.endDate > due_date){
            self.showBanner(title: "", withMessage: "Recruiter requires the candidate interview to be completed before the \(feedbackDueDate.text!) you selected. Please choose the slots on or before \(dueDate_string).", style: .warning)
            return
        }
        self.errorLabel.text = ""
        let currentDate = cal.date(byAdding: .hour, value: 1, to: Date())
        let timeWithEightandHalf1 = currentDate?.string(format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? ""
        let utcTime1 = self.localToUTC(date: timeWithEightandHalf1, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime1 = self.convertUTCToLocalTimeZone(date: utcTime1,withTimeZone: self.currentTimeZone)
         print(recruiterTime1)
        
        dateFormatter.dateFormat = "hh:mm"
        if (startDate < recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")) {
            //weekView.scrollWeekView(to: cal.date(byAdding: .hour, value: 1, to: Date()) ?? Date())
            self.showBanner(title: "", withMessage: "You are trying create slot in past time", style: .warning)
            return
        }
        var status = true
        for i in 0..<viewModel.events.count {
            if (viewModel.events[i].startDate == newEvent.startDate && viewModel.events[i].endDate == newEvent.endDate) {
                self.showBanner(title: "", withMessage: "You are trying to provide already existing time slot", style: .warning)
                status = false
                return
            }
        }
        
        if(status == true) {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            let timeSlot = dateformatter.string(from: startDate)
            // let utcDate = self.localToUTC(date: timeSlot)
            let utcDate = self.localToUTC(date: timeSlot,withTimeZone: self.currentTimeZone)
            
            
            print("========================Appended Time Slot====================")
            print(utcDate)
            print(timeSlot)
            self.timeSlots.append(utcDate)
            viewModel.events.append(newEvent)
        }
        
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
    }
    
    /*
     func localToUTC(date:String) -> String {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
     // dateFormatter.calendar = NSCalendar.current
     dateFormatter.timeZone = currentTimeZone
     
     let dt = dateFormatter.date(from: date)
     dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
     dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
     
     return dateFormatter.string(from: dt!)
     }*/
    
    
    func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        var cal = Calendar.current
        cal.timeZone = self.currentTimeZone
        guard let event = editingEvent as? AllDayEvent else { return }
        let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
        let selectedIndex = viewModel.events.firstIndex(where: { $0.id == event.id })!
        var status = true
        
        let due_date =  Calendar.current.date(byAdding: .hour, value: -5, to: dueDatePicker.date)!
        dateFormatter.dateFormat =  "dd-MMMM-yyyy hh:mm a"
        let dueDate_string = dateFormatter.string(from: Calendar.current.date(byAdding: .minute, value: -30, to: due_date)!)
        if(startDate.add(component: .hour, value: 1) > due_date){
            self.showBanner(title: "", withMessage: "Recruiter requires the candidate interview to be completed before the \(feedbackDueDate.text!) you selected. Please choose the slots on or before \(dueDate_string).", style: .warning)
            return
        }
        self.errorLabel.text = ""
        let currentDate = cal.date(byAdding: .hour, value: 1, to: Date())
        let timeWithEightandHalf1 = currentDate?.string(format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? ""
        let utcTime1 = self.localToUTC(date: timeWithEightandHalf1, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime1 = self.convertUTCToLocalTimeZone(date: utcTime1,withTimeZone: self.currentTimeZone)
        dateFormatter.dateFormat = "hh:mm"
        
        if (startDate < recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")) {
            self.showBanner(title: "", withMessage: "You are trying create slot in past time", style: .warning)
            return
        }
        for i in 0..<viewModel.events.count {
            if (viewModel.events[i].startDate == startDate && viewModel.events[i].endDate == startDate.add(component: .minute, value: duration)) {
                self.showBanner(title: "", withMessage: "You are trying to provide already existing time slot", style: .warning)
                status = false
                return
            }
        }
        if(status == true) {
            viewModel.events[selectedIndex].startDate = startDate
            viewModel.events[selectedIndex].endDate = startDate.add(component: .minute, value: duration)
            viewModel.events[selectedIndex].title = "\(dateFormatter.string(from: startDate)) \n - \n \(dateFormatter.string(from: startDate.add(component: .minute, value: duration)))"
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            let timeSlot = dateformatter.string(from: startDate)
            //  let utcDate = self.localToUTC(date: timeSlot)
            let utcDate = self.localToUTC(date: timeSlot,withTimeZone: self.currentTimeZone)
            
            timeSlots[selectedIndex] = utcDate
            viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
            weekView.forceReload(reloadEvents: viewModel.eventsByDate)
        }
    }
    
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        if let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? EventCell {
            view.titleLabel.text = ""
            return view
        }
        
        return UIView()
    }
}

// For example only
extension ProvideAvailabiltyViewController {
    
    func setupBasic() {
        // Add this to fix lower than iOS11 problems
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func loadCandidates() {
        self.showSpinner()
        currentPage += 1
        
        self.candidatesAPI.getCandidates(manager: CandidatesManager(jobID: jobID, status: .all,page: "\(currentPage)",perPage: "\(100)",searchKeyWord: "",statusKey: "status")) { (response, error) in
            
            let success = response?["success"] as? Bool ?? false
            
            if success {
                
                DispatchQueue.main.async {
                    
                    self.totalCandidatesCount = response?["total_count"] as? Int ?? 0
                    self.jobStatus = response?["status"] as? String ?? ""
                    
                    if let candidates = response?["candidates"] as? [Dictionary<String,Any>] {
                        
                        self.candidatesArray = candidates

                        print(self.candidatesArray.count)
                        
                        if self.candidatesArray.count > 0 {
                            
                            for i in 0..<self.candidatesArray.count {
                                
                                let candidate = self.candidatesArray[i]
                                
                                if let status = candidate["status"] as? String  {
                                    
                                    if status != .withdrawn && status != .completed {
                                        
                                        self.isCandidatesAvailable = true
                                        
                                        self.selectedCandidate.text = candidate["full_name"] as? String ?? ""
                                        if let cID = candidate["id"] as? Int {
                                            self.candidateID = "\(cID)"
                                        }
                                        
                                        if let candidateTimeZone = candidate["time_zone"] as? String {
                                            
                                            for dict in LocalCountry.timezoneList {
                                                for (key,value) in dict {
                                                    
                                                    if key == candidateTimeZone {
                                                        self.timezoneTextField.text = value
                                                        self.selectedTimeZoneCode = key
                                                                                          self.currentTimeZone = TimeZone(identifier: key) ?? TimeZone.current
                                                    }
                                                }
                                            }
                                        }

                                        
                                        if let reportDueBy = candidate["feedback_due_by"]  as? String {
                                            
                                            self.prefferedInterViewTime = reportDueBy
                                            self.updateFeedBackDate()
                                            
                                        }
                                        
                                        
                                        if let candidateAvailabilities = candidate["availabilities"] as? [Dictionary<String,Any>] {
                                            self.viewModel.events.removeAll()
                                            self.timeSlots.removeAll()
                                            
                                            for i in 0..<candidateAvailabilities.count {
                                                
                                                let dict =  candidateAvailabilities[i]
                                                if let startTime = dict["start_time"] as? String {
                                                    self.timeSlots.append(startTime)
                                                    let localStartTime = self.convertUTCToLocalTimeZone(date: startTime,withTimeZone: self.currentTimeZone)
                                                    let formatedStartDate = localStartTime.toDateGeneric()
                                                    self.viewModel.events.append(AllDayEvent(id: UUID().uuidString, title: "", startDate: formatedStartDate, endDate: formatedStartDate.add(component: .hour, value: 1), location: "", isAllDay: false))
                                                }
                                            }
                                            
                                            self.updateDateAndTime()
                                        }
                                        
                                        self.removeSpinner()
                                        
                                        return
                                        
                                        
                                    } else {
                                        self.isCandidatesAvailable = false
                                    }
                                    
                                    
                                }
                            }
                            
                        } else {
                            self.isCandidatesAvailable = false
                            self.showBanner(title: "", withMessage: "No Candidates to show.", style: .warning)
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

extension ProvideAvailabiltyViewController {
    
    func showPicker() {
        
        print(jobClosedDate)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = jobClosedDate.changeDate(jobClosedDate)
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        dueDatePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date.toDate())
        dueDatePicker.minuteInterval = 30
        dueDate = dueDatePicker.date
        
        let toolbar = self.setUpToolBar()
        feedbackDueDate.inputAccessoryView = toolbar
        feedbackDueDate.inputView = dueDatePicker
        feedbackDueDate.becomeFirstResponder()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker() {
        
        self.validateDateAndTime()
    }
    
    func showDateValidation(message: String , status: Bool){
        self.showBanner(title: "", withMessage: message, style: .warning)
        dueDatePicker.date = dueDate
    }
    
    func validateDateAndTime() {
        
        if jobClosedDate != "" {
            
            dateFormatter.dateFormat = Formats.dateFormat
            
            let feedBackDate = jobClosedDate.changeDate(jobClosedDate).toDate()
            let dueDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: feedBackDate) ?? Date()
            
            guard let dateFieldArray = feedbackDueDate.text?.components(separatedBy: " ") else {return}
            print(dueDatePicker.date.toString(format: Formats.time_12hours_format))
            if(dueDatePicker.date.toString(format: Formats.time_12hours_format) == "12:00 AM" && dateFieldArray[0] != dueDatePicker.date.toString(format: Formats.dateFormat)){
                
                if let pickerDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: dueDatePicker.date) {
                    dueDatePicker.date = pickerDate
                }
            }
            
            
            let mindate = Calendar.current.date(bySettingHour: 20, minute: 45, second: 00, of: dueDatePicker.date) ?? Date()
            
            if(dueDatePicker.date < Date(timeIntervalSinceNow: 30600) || dueDate < Date() || dueDatePicker.date > dueDate) {
                if(Calendar.current.dateComponents([.day , .month , .year], from: dueDatePicker.date) == Calendar.current.dateComponents([.day , .month , .year], from: feedBackDate) && dueDatePicker.date > mindate) {
                    showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
                } else {
                    showDateValidation(message: "Candidate preferred interview time should be 8 hours 30 minutes greater than current time" , status: true)
                }
            } else if(Calendar.current.dateComponents([.day , .month , .year], from: dueDatePicker.date) == Calendar.current.dateComponents([.day , .month , .year], from: feedBackDate) && dueDatePicker.date > mindate) {
                
                showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
            } else {
                
                self.feedbackDueDate.text = dueDatePicker.date.string(format: Formats.date_timeFormat)
                let dateformatter = DateFormatter()
                dateformatter.timeZone = self.currentTimeZone
                dateformatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'" //"yyyy-MM-dd'T'HH:mm:ssZ"/
                let feedBackDueDate = dateformatter.string(from: dueDatePicker.date)
                self.prefferedInterViewTime = feedBackDueDate
                print(self.prefferedInterViewTime)
                
            }
            
            
            self.view.endEditing(true)
            
        }
    }
}

extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}

extension ProvideAvailabiltyViewController {
    
    func setUpToolBar() -> UIView {
        
        let customToolBar = UIView()
        customToolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width,
                                     height: 50)
        
        let doneButton = UIButton(frame: CGRect(x: 8, y: 0, width: 50, height: 50))
        doneButton.addTarget(self, action: #selector(donedatePicker), for: .touchUpInside)
        doneButton.light(size: 18.0)
        

        doneButton.setTitle("Done", for: .normal)
        customToolBar.addSubview(doneButton)
        
        
        let cancelButton = UIButton(frame: CGRect(x: ScreenSize.width-58, y: 0, width: 50, height: 50))
        cancelButton.addTarget(self, action: #selector(cancelDatePicker), for: .touchUpInside)
        cancelButton.light(size: 18.0)

        cancelButton.setTitle("Cancel", for: .normal)
        customToolBar.addSubview(cancelButton)
        
        customToolBar.backgroundColor = AppTheme.brandColor
        customToolBar.sizeToFit()
        return customToolBar
    }
    
}
