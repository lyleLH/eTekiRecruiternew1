//
//  CandidateAvailibilityViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 06/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
import JZCalendarWeekView

class CandidateAvailibilityViewControllerTests: XCTestCase {

    var candidateAvailibilityViewController: ProvideAvailabiltyViewController!
    var candidateAvailibilityNavigationController: UINavigationController!
    var moreActions = MoreActionsViewController()
    let currentDate = "04-11-2019"
    let eventCell = LongPressEventCell()
    
    override func setUp() {
        super.setUp()
        candidateAvailibilityViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProvideAvailabiltyViewController") as? ProvideAvailabiltyViewController
        candidateAvailibilityNavigationController = UINavigationController(rootViewController: candidateAvailibilityViewController)
        let stubData = ["due_at": "2019-12-25", "page": 1, "total_count": 1, "time_zone": "US/Samoa", "candidates": [[
            "availabilities" :  [
                "2019-12-09T08:00:00.000Z",
                "2019-12-10T08:00:00.000Z"
            ],
            "feedback_due_by" : "2019-12-20T06:30:00.000Z",
            "first_name" : "one",
            "full_name" : "one k",
            "id" : 19732,
            "job_id" : 3545,
            "last_name" : "k",
            "phone" : "2015454545",
            "profile_pics" :    [
            "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
            "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
            "status" : "Pending Interview",
            "time_zone" : "US/Samoa: (GMT11:00) American Samoa, Midway Island",
        ]], "success": 1, "per_page": 100, "status": "Active", "job_title": "dfgf"] as [String : Any]
        CandidateStubApi.getCandidatesresponse = stubData
        candidateAvailibilityViewController.candidatesAPI = CandidateStubApi.self
        candidateAvailibilityViewController.view.layoutIfNeeded()
        candidateAvailibilityNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = candidateAvailibilityNavigationController
    }
    
    func testSetupCalendar(){
        AllDayViewModel()
        ToastUtil.toastMessageInTheMiddle(message: "", bgColor: .white, existTime: TimeInterval())
        let defaultWeekView =   DefaultWeekView()
        let newEvent1 = AllDayEvent(id: "1", title: "event1", startDate: Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: Date())!, endDate: Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: Date())!, location: "", isAllDay: false)
        candidateAvailibilityViewController.calendarWeekView.allEventsBySection = [Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: Date())! : [newEvent1]]
       candidateAvailibilityViewController.calendarWeekView.getCurrentEvent(with: IndexPath(item: 0, section: 0))
        candidateAvailibilityViewController.calendarWeekView.collectionView(candidateAvailibilityViewController.calendarWeekView.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        LongPressWeekView()
    }
    
    /*! @brief Scenario Long press Event cell Configuration */
    func testLongPressEventCellConfiguration(){
        if let view = UINib(nibName: LongPressEventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LongPressEventCell {
            view.titleLabel.text = ""
            let newEvent = AllDayEvent(id: "1", title: "event1", startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: 7, to: Date())!, location: "", isAllDay: false)
            view.configureCell(event: newEvent, isAllDay: false)
        }
    }
    
    
    func testInstance() {
        XCTAssertNotNil(candidateAvailibilityViewController, "Not able to create candidateAvailibilityViewController Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.selectedCandidate, "Not able to create selectedCandidate Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.selectedDate, "Not able to create selectedDate Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.timezoneTextField, "Not able to create timezoneTextField Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.feedBackDueDate, "Not able to create feedBackDueDate Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.calendarWeekView, "Not able to create calendarWeekView Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.submitButton, "Not able to create calendarWeekView Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.candidateView, "Not able to create candidateView Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.candidateButton, "Not able to create candidateButton Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.candidateDropImage, "Not able to create candidateDropImage Instance.")
        XCTAssertNotNil(candidateAvailibilityViewController.calendarButton, "Not able to create candidateDropImage Instance.")
    }
    
    /*! @brief Scenario when user taps on job_due date */
    func testShowPicker(){
        candidateAvailibilityViewController.calendarButton.sendActions(for: .touchUpInside)
    }
    
     /*! @brief Scenario when user taps on submit Button with Empty times slots*/
    func testSubmitAvailableSlots(){
        let candidateManger = CandidatesManager(jobID: "19697", candidateId: "19697", currentTimeZone: "US/Samoa", prefferedInterViewTime: "2019-12-25T10:00:00.000Z", timeSlots: [
            "2019-12-09T08:00:00.000Z",
            "2019-12-10T08:00:00.000Z"
        ])
        let stubData =  ["candidate_status": "Waiting for Interviewer", "success": 1, "message": ["Availability updated successfully."]] as [String : Any]
        CandidateStubApi.updateAvailibility = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.updateCandidateAvailibity(candidateManager: candidateManger)
        candidateAvailibilityViewController.submitButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(candidateAvailibilityViewController.timeSlots.count, 0)
    }
    
    /*! @brief Scenario when user taps on submit Button with less than 3 times slots*/
    func testSubmitAvailableSlots1(){
        let slots = ["2019-12-06 16:34:09.151618+0530", "2019-12-06 16:34:09.151618+0530"]
        candidateAvailibilityViewController.timeSlots = slots
        candidateAvailibilityViewController.submitButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(candidateAvailibilityViewController.timeSlots.count, slots.count)
    }
    
    /*! @brief Scenario when user taps on submit Button with more than 3 times slots*/
    func testSubmitAvailableSlots2(){
        let slots = ["2019-12-06 16:34:09.151618+0530", "2019-12-06 16:34:09.151618+0530", "2019-12-06 16:34:09.151618+0530" , "2019-12-06 16:34:09.151618+0530"]
        candidateAvailibilityViewController.timeSlots = slots
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.submitButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(candidateAvailibilityViewController.timeSlots.count, slots.count)
    }
    
    func testBackAction(){
        candidateAvailibilityViewController.backAction(0)
    }
    
    /*! @brief Scenario when user taps on candidate button with no candidate availibility*/
    func testCandidateToSearch(){
        let candidateAvailable = false
        candidateAvailibilityViewController.isCandidatesAvailable = candidateAvailable
        candidateAvailibilityViewController.candidateButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(candidateAvailibilityViewController.isCandidatesAvailable, candidateAvailable)
    }
    
    /*! @brief Scenario when user taps on timzone dropdown */
    func testCandidateToAvailibility(){
        candidateAvailibilityViewController.timeZoneDrodownButton.sendActions(for: .touchUpInside)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let candidatesViewController = UIApplication.topMostViewController() as? SearchViewController else {
                XCTFail("SearchViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(candidatesViewController, "Not able to Navigate SearchViewController, instance is nil.")
            candidatesViewController.view.layoutIfNeeded()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    /*! @brief Scenario when user taps on removeSlot */
    func testRemoveSlot(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedEvent" : AllDayEvent(id: "1", title: "event1", startDate: Date(), endDate: Date(timeIntervalSinceNow: 3600), location: "", isAllDay: false)])
        candidateAvailibilityViewController.removeSlot(notfication: notification)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let customAlertViewController = UIApplication.topViewController() as? CustomAlertViewController else {
                XCTFail("CustomAlertViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(customAlertViewController, "Not able to Navigate CustomAlertViewController, instance is nil.")
            customAlertViewController.view.layoutIfNeeded()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    /*! @brief Scenario when user taps on removeSlot Confirmation */
    func testRemoveSlotConfirmation(){
        candidateAvailibilityViewController.timeSlots = ["2019-12-09T05:03:03.000Z", "2019-02-09T04:57:00.000Z"]
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedEvent" : Date()])
        candidateAvailibilityViewController.timeSlots = ["\(Date())"]
        let newEvent = AllDayEvent(id: "1", title: "event1", startDate: Date(), endDate: Date(timeIntervalSinceNow: 3600), location: "", isAllDay: false)
        candidateAvailibilityViewController.viewModel.events.append(newEvent)
        candidateAvailibilityViewController.removeSlotConfirmAction(notfication: notification)
    }
    
    /*! @brief Scenario when user select a timezone */
    func testUpdateTimezone(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["timezone": ["US/Samoa": "(GMT11:00) American Samoa, Midway Island"]])
        candidateAvailibilityViewController.timeSlots = ["2019-12-09T08:00:00.000Z", "2019-02-09T04:57:00.000Z"]
        candidateAvailibilityViewController.updateTimeZone(notfication: notification)
    }
    
    /*! @brief Scenario when user selects a feedBackdate */
    func testfeedBackdate(){
        candidateAvailibilityViewController.prefferedInterViewTime = "2019-12-01T10:00:00.000Z"
        candidateAvailibilityViewController.updateFeedBackDate()
    }
    
    /*! @brief Scenario when user selects a candidate from candidate list */
    func testGetCandidateDetails(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedCandidate" : ["id" : 19697, "full_name" : "Consectetur consequa Explicabo Harum max"]])
        let stubData =  ["success": 1, "candidate": [
            "feedback_due_by" : "2019-12-25T10:00:00.000Z",
            "full_name" : "Consectetur consequa Explicabo Harum max",
            "id" : 19697,
            "job_due_at" : "2019-12-26",
            "time_slots" : [
                "2019-12-09T08:00:00.000Z",
                "2019-12-10T08:00:00.000Z"
            ],
            "time_zone" : "US/Samoa"
            ]] as [String : Any]
        CandidateStubApi.candidateAvailibility = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.candidateDetails(notfication: notification)
    }
    
    /*! @brief Scenario when user creating a slot after the jobDuedate*/
    func testWeekViewDidEndAddNewLongPress(){
        let v = candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, didEndAddNewLongPressAt: Date())
    }
    
    /*! @brief Scenario when user creating a slot in past time*/
    func testAddNewLongPress(){
        candidateAvailibilityViewController.dueDatePicker.date = Date()
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, didEndAddNewLongPressAt: Calendar.current.date(byAdding: .hour, value: -7, to: Date())!)
    }
    
    /*! @brief Scenario when user creating a already exsited slot*/
    func testWeekViewAddNewLongPress(){
        let newEvent = AllDayEvent(id: UUID().uuidString, title: "event1", startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: 7, to: Date())!, location: "", isAllDay: false)
        candidateAvailibilityViewController.viewModel.events.append(newEvent)
        candidateAvailibilityViewController.dueDatePicker.date = Calendar.current.date(byAdding: .hour, value: 15, to: Date())!
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, didEndAddNewLongPressAt: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!)
    }
    
    /*! @brief Scenario when user editing a slot after the jobDuedate*/
    func testWeekViewDidEndEditNewLongPress(){
        let newEvent = AllDayEvent(id: "1", title: "event1", startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!, location: "", isAllDay: false)
        candidateAvailibilityViewController.viewModel.events.append(newEvent)
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, editingEvent: AllDayEvent(id: "1", title: "event2", startDate: Date(), endDate: Date(timeIntervalSinceNow: 3600), location: "", isAllDay: false), didEndMoveLongPressAt: Date())
    }
    
    /*! @brief Scenario when user editing a slot in past time*/
    func testEditNewLongPress(){
        let newEvent = AllDayEvent(id: "2", title: "event1", startDate: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: -7, to: Date())!, location: "", isAllDay: false)
        candidateAvailibilityViewController.viewModel.events.append(newEvent)
        candidateAvailibilityViewController.dueDatePicker.date = Date()
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, editingEvent: AllDayEvent(id: "2", title: "event2", startDate: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: -7, to: Date())!, location: "", isAllDay: false), didEndMoveLongPressAt: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!)
    }
    
    /*! @brief Scenario when user editing on a already exsited slot*/
    func testWeekViewEditNewLongPress(){
        let newEvent = AllDayEvent(id: "1", title: "event1", startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: 7, to: Date())!, location: "", isAllDay: false)
        candidateAvailibilityViewController.timeSlots = ["2019-12-09 13:16:08.328279+0530"]
        candidateAvailibilityViewController.viewModel.events.append(newEvent)
        candidateAvailibilityViewController.dueDatePicker.date = Calendar.current.date(byAdding: .hour, value: 15, to: Date())!
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, editingEvent: AllDayEvent(id: "1", title: "event2", startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: 7, to: Date())!, location: "", isAllDay: false), didEndMoveLongPressAt: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!)
    }
    
    /*! @brief Scenario when user created a slot that Apppearance */
    func testViewForslots(){
        if let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? EventCell {
            view.titleLabel.text = ""
            let newEvent = DefaultEvent(id: "1", title: "event1", startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .hour, value: 7, to: Date())!, location: "")
            view.configureCell(event: newEvent)
        }
        candidateAvailibilityViewController.weekView(candidateAvailibilityViewController.calendarWeekView, viewForAddNewLongPressAt: Date())
    }
    
    /*! @brief Scenario load Candidates*/
    func testLoadCandidates(){
        let stubData =  ["due_at": "2019-12-25", "page": 1, "total_count": 1, "time_zone": "US/Samoa", "candidates": [[
            "availabilities" :  [
                [
                    "candidate_id" : 19732,
                    "created_at" : "2019-12-09T08:55:32.000Z",
                    "id" : 37450,
                    "job_id" : 3545,
                    "start_time" : "2019-12-10T00:00:00.000Z",
                    "updated_at" : "2019-12-09T08:55:32.000Z",
                ],
                [
                    "candidate_id" : 19732,
                    "created_at" : "2019-12-09T08:55:32.000Z",
                    "id" : 37451,
                    "job_id" : 3545,
                    "start_time" : "2019-12-10T01:30:00.000Z",
                    "updated_at" : "2019-12-09T08:55:32.000Z",
                ],
            ],
            "feedback_due_by" : "2019-12-20T06:30:00.000Z",
            "first_name" : "one",
            "full_name" : "one k",
            "id" : 19732,
            "job_id" : 3545,
            "last_name" : "k",
            "phone" : "2015454545",
            "profile_pics" :    [
            "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
            "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
            "status" : "Pending Interview",
            "time_zone" : "US/Samoa: (GMT11:00) American Samoa, Midway Island",
        ]], "success": true, "per_page": 100, "status": "Active", "job_title": "dfgf"] as [String : Any]
        CandidateStubApi.getCandidatesresponse = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.loadCandidates()
    }
    
    /*! @brief Scenario load Candidates with completed/withdrawn status*/
    func testLoadCandidatesWithCompletedStatus(){
        let stubData =  ["due_at": "2019-12-25", "page": 1, "total_count": 1, "time_zone": "US/Samoa", "candidates": [[
            "availabilities" :  [
            ],
            "feedback_due_by" : "2019-12-20T06:30:00.000Z",
            "first_name" : "one",
            "full_name" : "one k",
            "id" : 19732,
            "job_id" : 3545,
            "last_name" : "k",
            "phone" : "2015454545",
            "profile_pics" :    [
            "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
            "status" : "Completed",
            "time_zone" : "US/Samoa: (GMT11:00) American Samoa, Midway Island",
        ]], "success": true, "per_page": 100, "status": "Active", "job_title": "dfgf"] as [String : Any]
        CandidateStubApi.getCandidatesresponse = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.loadCandidates()
    }
    
    /*! @brief Scenario load Candidates with Empty list*/
    func testLoadCandidatesWithEmptyList(){
        let stubData =  ["due_at": "2019-12-25", "page": 1, "total_count": 1, "time_zone": "US/Samoa", "candidates": [], "success": true, "per_page": 100, "status": "Active", "job_title": "dfgf"] as [String : Any]
        CandidateStubApi.getCandidatesresponse = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateAvailibilityViewController.loadCandidates()
    }
    
    /*! @brief Scenario when user convert time to global time*/
    func testToGlobalTime(){
       candidateAvailibilityViewController.jobClosedDate = ""
        candidateAvailibilityViewController.validateDateAndTime()
        candidateAvailibilityViewController.jobClosedDate = currentDate
        candidateAvailibilityViewController.dueDatePicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: candidateAvailibilityViewController.dueDatePicker.date) ?? Date()
        candidateAvailibilityViewController.validateDateAndTime()
        candidateAvailibilityViewController.jobClosedDate = currentDate
        candidateAvailibilityViewController.dueDatePicker.date = Calendar.current.date(bySettingHour: 22, minute: 45, second: 00, of: Date()) ?? Date()
        candidateAvailibilityViewController.validateDateAndTime()
        candidateAvailibilityViewController.jobClosedDate = "2020-10-03"
        candidateAvailibilityViewController.dueDatePicker.date = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) ?? Date()
    }
    
    /*! @brief Scenario when user convert time to local time*/
    func testToLocalTime(){
        Date().toLocalTime()
    }
    
    /*! @brief Scenario when user taps on cancel Picker*/
    func testCancelPicker(){
        candidateAvailibilityViewController.cancelDatePicker()
    }
    
    /*! @brief Scenario when user taps on done Picker*/
    func testDonePicker(){
        candidateAvailibilityViewController.donedatePicker()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
