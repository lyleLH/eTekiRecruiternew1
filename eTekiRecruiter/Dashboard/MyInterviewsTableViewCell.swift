//
//  MyInterviewsTableViewself.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 13/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

protocol MyInterviewsTableViewCellDelegate {
    func updateResponseToView(data : Any, withType type : String)
    func updateError(error : ErrorResponse, withType type : String)
}

// MARK: InterviewAction Types
struct InterviewActionTypes {
    static let closeInterview = "Close Interview"
    static let showReport = "Show Report"
    static let showVideos = "Show Videos"
    static let joinVideos = "Join Videos"
    static let showAnalytics = "Show Analytics"
    static let showRating = "Show Rating"
    static let showPayments = "Show Payments"
    static let showReason = "Show Reason"
    static let noShow = "No Show"
    static let showAvailabilty = "Show Availabilty"
    static let withdrawInterview = "Withdraw Interview"
    static let shareInterview = "Share Interview"
}

class MyInterviewsTableViewCell: BaseViewCell {

    var sectionTitle = ""
    var delegate : MyInterviewsTableViewCellDelegate?

    // MARK: Schedule - Stack
    @IBOutlet weak var scheduledCloseIcn: UIImageView!
    @IBOutlet weak var scheduledCloseBtn: UIButton!
    @IBOutlet weak var scheduledWithDrawIcon: UIImageView!
    @IBOutlet weak var scheduledWithdrawBtn: UIButton!
    @IBOutlet weak var scheduledShareIcon: UIImageView!
    @IBOutlet weak var scheduledShareBtn: UIButton!
    @IBOutlet weak var scheduledJoinVideoIcon: UIImageView!
    @IBOutlet weak var scheduledJoinVideoBtn: UIButton!

    // MARK: In Progress - Stack
    @IBOutlet weak var inProgressShowVideosIcon: UIImageView!
    @IBOutlet weak var inProgressShowVideosButton: UIButton!
    @IBOutlet weak var inProgressWithDrawicon: UIImageView!
    @IBOutlet weak var inProgressWithDrawBtn: UIButton!
    @IBOutlet weak var inProgressShareIcon: UIImageView!
    @IBOutlet weak var inProgressShareBtn: UIButton!
    @IBOutlet weak var inProgressJoinVideoIcon: UIImageView!
    @IBOutlet weak var inProgressJoinVideoBtn: UIButton!

    // MARK: Pending Report - Stack
    @IBOutlet weak var pendingReportIcn: UIImageView!
    @IBOutlet weak var pendingReportBtn: UIButton!
    @IBOutlet weak var pendingReportShareIcon: UIImageView!
    @IBOutlet weak var pendingReportShareBtn: UIButton!
    @IBOutlet weak var pendingReportRatingIcon: UIImageView!
    @IBOutlet weak var pendingReportRatingBtn: UIButton!
    @IBOutlet weak var pendingReportShowVideosIcon: UIImageView!
    @IBOutlet weak var pendingReportShowVideosBtn: UIButton!

    // MARK: Pending Approval - Stack
    @IBOutlet weak var pendingApprovalReportIcn: UIImageView!
    @IBOutlet weak var pendingApprovalReportBtn: UIButton!
    @IBOutlet weak var pendingApprovalShareIcon: UIImageView!
    @IBOutlet weak var pendingApprovalShareBtn: UIButton!
    @IBOutlet weak var pendingApprovalRatingIcon: UIImageView!
    @IBOutlet weak var pendingApprovalRatingBtn: UIButton!
    @IBOutlet weak var pendingApprovalShowVideosIcon: UIImageView!
    @IBOutlet weak var pendingApprovalShowVideosBtn: UIButton!

    // MARK: Pending Resubmission - Stack
    @IBOutlet weak var pendingResubmissionReportIcn: UIImageView!
    @IBOutlet weak var pendingResubmissionReportBtn: UIButton!
    @IBOutlet weak var pendingResubmissionShareIcon: UIImageView!
    @IBOutlet weak var pendingResubmissionShareBtn: UIButton!
    @IBOutlet weak var pendingResubmissionRatingIcon: UIImageView!
    @IBOutlet weak var pendingResubmissionRatingBtn: UIButton!
    @IBOutlet weak var pendingResubmissionShowVideosIcon: UIImageView!
    @IBOutlet weak var pendingResubmissionShowVideosBtn: UIButton!

    // MARK: Pending Payments - Stack
    @IBOutlet weak var pendingPaymentShareIcon: UIImageView!
    @IBOutlet weak var pendingPaymentShareBtn: UIButton!

    @IBOutlet weak var pendingPaymentPayIcon: UIImageView!
    @IBOutlet weak var pendingPaymentPayBtn: UIButton!

    @IBOutlet weak var pendingPaymentReportIcon: UIImageView!
    @IBOutlet weak var pendingPaymentReportBtn: UIButton!

    @IBOutlet weak var pendingPaymentShowVideosIcon: UIImageView!
    @IBOutlet weak var pendingPaymentShowVideosBtn: UIButton!

    // MARK: Completed - Stack
    @IBOutlet weak var completedReportIcon: UIImageView!
    @IBOutlet weak var completedReportBtn: UIButton!

    @IBOutlet weak var completedShareIcon: UIImageView!
    @IBOutlet weak var completedShareBtn: UIButton!

    @IBOutlet weak var completedRatingIcon: UIImageView!
    @IBOutlet weak var completedRatingBtn: UIButton!

    @IBOutlet weak var completedAnalyticsIcon: UIImageView!
    @IBOutlet weak var completedAnalyticsBtn: UIButton!

    // MARK: Canceled - Stack
    @IBOutlet weak var canceledReasonIcon: UIImageView!
    @IBOutlet weak var canceledReasonBtn: UIButton!
    @IBOutlet weak var canceledPayIcon: UIImageView!
    @IBOutlet weak var canceledPayBtn: UIButton!
    @IBOutlet weak var canceldWithdrawIcon: UIImageView!
    @IBOutlet weak var canceldWithdrawBtn: UIButton!
    @IBOutlet weak var canceldShowVideosIcon: UIImageView!
    @IBOutlet weak var canceldShowVideosBtn: UIButton!

    // MARK: Waiting On Candidate - Stack
    @IBOutlet weak var wocAvailabityIcon: UIImageView!
    @IBOutlet weak var wocAvailabityBtn: UIButton!
    @IBOutlet weak var wocWithdrawIcon: UIImageView!
    @IBOutlet weak var wocWithdrawBtn: UIButton!
    @IBOutlet weak var wocShareIcon: UIImageView!
    @IBOutlet weak var wocShareBtn: UIButton!

    @IBOutlet weak var wocJoinVideoIcon: UIImageView!
    @IBOutlet weak var wocJoinVideoBtn: UIButton!

    // MARK: Waiting On Interview - Stack
    @IBOutlet weak var woiAvailabityIcon: UIImageView!
    @IBOutlet weak var woiAvailabityBtn: UIButton!
    @IBOutlet weak var woiWithdrawIcon: UIImageView!
    @IBOutlet weak var woiWithdrawBtn: UIButton!
    @IBOutlet weak var woiShareIcon: UIImageView!
    @IBOutlet weak var woiShareBtn: UIButton!

    @IBOutlet weak var woiJoinVideoIcon: UIImageView!
    @IBOutlet weak var woiJoinVideoBtn: UIButton!

    // MARK: No Show - Stack
    @IBOutlet weak var noshowReasonIcon: UIImageView!
    @IBOutlet weak var noshowReasonBtn: UIButton!
    @IBOutlet weak var noshowPayIcon: UIImageView!
    @IBOutlet weak var noshowPayBtn: UIButton!
    @IBOutlet weak var noshowWithdrawIcon: UIImageView!
    @IBOutlet weak var noshowWithdraBtn: UIButton!

    @IBOutlet weak var noshowShowVideosIcon: UIImageView!
    @IBOutlet weak var noshowShowVideosBtn: UIButton!

    // MARK: Incomplete - Stack
    @IBOutlet weak var incompleteReasonIcon: UIImageView!
    @IBOutlet weak var incompleteReasonBtn: UIButton!
    @IBOutlet weak var incompletePayIcon: UIImageView!
    @IBOutlet weak var incompletePayBtn: UIButton!
    @IBOutlet weak var incompleteWithdrawIcon: UIImageView!
    @IBOutlet weak var incompleteWithdraBtn: UIButton!
    @IBOutlet weak var incompleteShowVideosIcon: UIImageView!
    @IBOutlet weak var incompleteShowVideosBtn: UIButton!

    @IBOutlet weak var interviewActionsStack: UIStackView!
    @IBOutlet weak var scheduledStack: UIStackView!
    @IBOutlet weak var inProgressStack: UIStackView!
    @IBOutlet weak var pendingReport: UIStackView!
    @IBOutlet weak var pendingApproval: UIStackView!
    @IBOutlet weak var pendingResubmission: UIStackView!
    @IBOutlet weak var pendingPayment: UIStackView!
    @IBOutlet weak var completedStack: UIStackView!
    @IBOutlet weak var cancelledStack: UIStackView!
    @IBOutlet weak var waitingOnCandidate: UIStackView!
    @IBOutlet weak var waitingOnInterview: UIStackView!
    @IBOutlet weak var noShowStack: UIStackView!
    @IBOutlet weak var incompleteStack: UIStackView!


    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cellBorderView: UIView!
    @IBOutlet weak var cellBorderLabel: UILabel!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var reportDate: UILabel!
    @IBOutlet weak var interviewerLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var bottomBorderView: UILabel!
    @IBOutlet weak var proxyImage: UIImageView!
    @IBOutlet weak var contributorFlagIcon: UIButton!
    var dataResponse = [String : Any]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

// MARK: Interview View Actions
extension MyInterviewsTableViewCell {
    // MARK: Withdraw action 1
    @IBAction func withDrawInterview(_ sender: UIButton) {

        let candidateId = dataResponse["candidate"] as? [String : Any]
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)

        if let id = candidateId?["id"] as? Int {
            let info = ["name": "withdraw", "id": "\(id)","job_id": "\(jobId)","indexpath" : indexPath] as [String : Any]
            self.delegate?.updateResponseToView(data: info, withType: InterviewActionTypes.withdrawInterview)
        }
    }

    // MARK: Rate Interview action 2
    @IBAction func rateInterviewer(_ sender: UIButton) {
        let interviewId = dataResponse["id"] as? Int ?? 0
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)
        let info = [ "job_id": jobId, "indexpath" : indexPath, "interviewId": interviewId] as [String : Any]
        self.delegate?.updateResponseToView(data: info, withType: InterviewActionTypes.showRating)
    }

    // MARK: Payment action 3
    @IBAction func paymentAction(_ sender: UIButton) {
        self.delegate?.updateResponseToView(data: "", withType: InterviewActionTypes.showPayments)
    }

    // MARK: Analytics action 4
    @IBAction func analyticsAction(_ sender: UIButton) {

        let candidate = dataResponse["candidate"] as? [String : Any]
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let candidateId = candidate?["id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)
        let data = ["job_id": jobId,  "indexpath" : indexPath, "candidateId": candidateId] as [String : Any]
        self.delegate?.updateResponseToView(data: data, withType: InterviewActionTypes.showAnalytics)
    }

    // MARK: Reason action 5
    @IBAction func reasonAction(_ sender: UIButton) {

        let interviewId = dataResponse["id"] as? Int ?? 0
        if(dataResponse["status"] as? String == "No Show"){
            if let reason = dataResponse["no_show_reason"] as? String {
                self.delegate?.updateResponseToView(data: reason, withType: InterviewActionTypes.noShow)
            }
        } else {
            let interviewID = "\(interviewId)"
            self.delegate?.updateResponseToView(data: interviewID, withType: InterviewActionTypes.showReason)
        }


    }

    // MARK: Availabilty action 6
    @IBAction func availabilty(_ sender: UIButton) {

        let candidate = dataResponse["candidate"] as? [String : Any]
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)


        if(candidate?["status"] as? String == "Withdrawn" || candidate?["status"] as? String == "Completed") {
            let error = ErrorResponse(responseCode: 0, message: "No Candidates to show, Candidates are either withdrawn or completed.", tittle: "")
            self.delegate?.updateError(error: error, withType: InterviewActionTypes.showAvailabilty)
        } else {
            let info = ["name": "myInterviews", "job_id": jobId, "candidateId": candidate?["id"] as? Int ?? 0,"indexpath" : indexPath] as [String : Any]
            self.delegate?.updateResponseToView(data: info, withType: InterviewActionTypes.showAvailabilty)
        }
    }

    // MARK: Close Interview action 7
    @IBAction func closeInterviewAction(_ sender: UIButton) {

        let candidateId = dataResponse["candidate"] as? Dictionary<String, Any>
        let interviewId = dataResponse["id"] as? Int
        let startTime = dataResponse["start_time"] as? String ?? ""
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)


        if let id = interviewId {
            let info = ["job_id":"\(jobId)","name": "myInterviewsCancelInterview", "id": "\(id)" , "startTime": self.convertUTCToLocalTimeZone(date: startTime), "title": sectionTitle, "candidateId": candidateId?["id"] as? Int ?? 0,"indexpath" : indexPath] as [String : Any]
            self.delegate?.updateResponseToView(data: info, withType: InterviewActionTypes.closeInterview)
        }

    }

    // MARK: Report action 8
    @IBAction func reportAction(_ sender: UIButton) {
        let interviewCode = dataResponse["interview_code"] as? String ?? ""
        let jobId = dataResponse["job_id"] as? Int ?? 0
        let indexPath = getIndexPath(index: sender.tag)
        let data = ["interview_code": interviewCode, "job_id": jobId,  "indexpath" : indexPath, ] as [String : Any]
        self.delegate?.updateResponseToView(data: data, withType: InterviewActionTypes.showReport)
    }

    // MARK: ShowVideos action 9
    @IBAction func showVideos(_ sender: UIButton) {

        let interviewCode = dataResponse["interview_code"] as? String ?? ""
        self.delegate?.updateResponseToView(data: interviewCode, withType: InterviewActionTypes.showVideos)

    }

    // MARK: Join Video action 10
    @IBAction func joinVideo(_ sender: UIButton) {
        self.delegate?.updateResponseToView(data: "", withType: InterviewActionTypes.joinVideos)

    }

    // MARK: Share Interview action 11
    @IBAction func shareInteview(_ sender: UIButton) {

        let jobId = dataResponse["job_id"] as? Int ?? 0
        let status = dataResponse["status"] as? String ?? ""
        let interviewCode = dataResponse["interview_code"] as? String ?? ""
        let indexPath = getIndexPath(index: sender.tag)

        let info = ["job_id": jobId, "status": status , "interview_code": interviewCode,"indexpath" : indexPath] as [String : Any]
        self.delegate?.updateResponseToView(data: info, withType: InterviewActionTypes.shareInterview)

    }

    func getIndexPath(index : Int) -> IndexPath {

        let section = index / 100
        let row = index % 100
        let reloadIndexpath = IndexPath(row: row, section: section)
        return reloadIndexpath

    }
}

extension MyInterviewsTableViewCell {

    func setAlphaValuesForIcons(imageView : UIImageView, status : Bool) {
        if !status {
            imageView.alpha = 0.5
        } else {
            imageView.alpha = 1.0
        }
    }

    func setIconsBasedonStatus(status: String, permissions: [String : Any], isCollaborate: Bool, reason: String, currency: String, candidateStatus: String, proxyStatus: Bool, tag : Int) {

        DispatchQueue.main.async {

            for stack in self.interviewActionsStack.arrangedSubviews {
                stack.isHidden = true
            }

            let payStatus = false
            var withdrawStatus = true
            var showVideoStatus = false
            if(candidateStatus == "Withdrawn"){
                withdrawStatus = false
            }

            if(proxyStatus && (status == MyinterviewsStatus.pendingReport || status == MyinterviewsStatus.pendingPayment || status == MyinterviewsStatus.pendingApproval || status == MyinterviewsStatus.pendingResubmission) ) {
                showVideoStatus = true
            }

            if(status == MyinterviewsStatus.scheduled) {

                self.scheduledStack.isHidden = false
                //Close Interview - Action 1
                self.scheduledCloseBtn.isEnabled = true
                self.scheduledCloseIcn.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.scheduledCloseBtn, imageView: self.scheduledCloseIcn, permissions: permissions, collaborate: isCollaborate, status: status)
                //Withdrawn Status - Action 2
                self.scheduledWithdrawBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.scheduledWithDrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.scheduledWithdrawBtn, imageView: self.scheduledWithDrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                //Share Button - Action 3
                self.scheduledShareBtn.isEnabled = true
                self.scheduledShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.scheduledShareBtn, imageView: self.scheduledShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                //Join Video - Action 4
                self.scheduledJoinVideoBtn.isEnabled = false //By Default
                self.scheduledJoinVideoIcon.alpha = 0.5 //By Default
               // self.updateReportPermission(button: self.scheduledJoinVideoBtn, imageView: self.scheduledJoinVideoIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.scheduledJoinVideoBtn.tag = tag
                self.scheduledShareBtn.tag = tag
                self.scheduledWithdrawBtn.tag = tag
                self.scheduledCloseBtn.tag = tag



            } else if(status == MyinterviewsStatus.inProgress) {

                self.inProgressStack.isHidden = false

                //Show Videos - Action 1
                self.inProgressShowVideosButton.isEnabled = true
                self.inProgressShowVideosIcon.alpha = 1.0
                self.updateReportPermission(button: self.inProgressShowVideosButton, imageView: self.inProgressShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                // InProgress - WithDraw Action 2
                self.inProgressWithDrawBtn.isEnabled = false
                self.inProgressWithDrawicon.alpha = 0.5
                self.updateWithdrawPermission(button: self.inProgressWithDrawBtn, imageView: self.inProgressWithDrawicon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Share Button - Action 3
                self.inProgressShareBtn.isEnabled = true
                self.inProgressShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.inProgressShareBtn, imageView: self.inProgressShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                // In Progress - join video Action 4
                self.inProgressJoinVideoBtn.isEnabled = false//By Default
                self.inProgressJoinVideoIcon.alpha = 0.5 //By Default
                //self.updateReportPermission(button: self.inProgressJoinVideoBtn, imageView: self.inProgressJoinVideoIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                self.inProgressShowVideosButton.tag = tag
                self.inProgressWithDrawBtn.tag = tag
                self.inProgressShareBtn.tag = tag
                self.inProgressJoinVideoIcon.tag = tag

            } else if status == MyinterviewsStatus.pendingReport {

                self.pendingReport.isHidden = false

                //Report Button - Action 1
                self.pendingReportBtn.isEnabled = false
                self.pendingReportIcn.alpha = 0.5
                self.updateReportPermission(button: self.pendingReportBtn, imageView: self.pendingReportIcn, permissions: permissions, collaborate: isCollaborate, status: status)

                //Share Button - Action 2
                self.pendingReportShareBtn.isEnabled = true
                self.pendingReportShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.pendingReportShareBtn, imageView: self.pendingReportShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Rating Button - Action 3
                self.pendingReportRatingBtn.isEnabled = false
                self.pendingReportRatingIcon.alpha = 0.5
                self.updateReportPermission(button: self.pendingReportRatingBtn, imageView: self.pendingReportRatingIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                //Show Videos - Action 4
                self.pendingReportShowVideosBtn.isEnabled = showVideoStatus
                self.setAlphaValuesForIcons(imageView: self.pendingReportShowVideosIcon, status: showVideoStatus)
                self.updateReportPermission(button: self.pendingReportShowVideosBtn, imageView: self.pendingReportShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                self.pendingReportBtn.tag = tag
                self.pendingReportShareBtn.tag = tag
                self.pendingReportRatingBtn.tag = tag
                self.pendingReportShowVideosBtn.tag = tag

                let interviewStatus = self.dataResponse["status"] as? String ?? ""
                let isProxied = self.dataResponse["is_proxied"] as? Bool ?? false


                if (interviewStatus == "Pending Report" &&  isProxied) {

                    if self.pendingReportShowVideosIcon.alpha != 1.0 {

                        self.pendingReportShowVideosIcon.image = UIImage(named: "eyeBorder")

                    } else {

                        let image1 = UIImage(named: "eyeBorder") ?? UIImage()
                        let image2 = UIImage(named: "eyefill") ?? UIImage()//add fill icon here
                        self.pendingReportShowVideosIcon.animationDuration = 0.5
                        self.pendingReportShowVideosIcon.animationImages = [image1,image2]
                        self.pendingReportShowVideosIcon.startAnimating()

                    }




                } else {

                    self.pendingReportShowVideosIcon.image = UIImage(named: "eye")
                    if self.pendingReportShowVideosIcon.isAnimating {
                        print("Still Animating")
                        self.pendingReportShowVideosIcon.stopAnimating()
                        self.pendingReportShowVideosIcon.image = UIImage(named: "eye")
                    }
                }




            } else if status == MyinterviewsStatus.pendingApproval {


                self.pendingApproval.isHidden = false

                //Report Button - Action 1
                self.pendingApprovalReportBtn.isEnabled = false
                self.pendingApprovalReportIcn.alpha = 0.5
                self.updateReportPermission(button: self.pendingApprovalReportBtn, imageView: self.pendingApprovalReportIcn, permissions: permissions, collaborate: isCollaborate, status: status)

                //Share Button - Action 2
                self.pendingApprovalShareBtn.isEnabled = true
                self.pendingApprovalShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.pendingApprovalShareBtn, imageView: self.pendingApprovalShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Rating Button - Action 3
                self.pendingApprovalRatingBtn.isEnabled = false
                self.pendingApprovalRatingIcon.alpha = 0.5
                self.updateReportPermission(button: self.pendingApprovalRatingBtn, imageView: self.pendingApprovalRatingIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                //Show Videos - Action 4
                self.pendingApprovalShowVideosBtn.isEnabled = showVideoStatus
                self.setAlphaValuesForIcons(imageView: self.pendingApprovalShowVideosIcon, status: showVideoStatus)
                self.updateReportPermission(button: self.pendingApprovalShowVideosBtn, imageView: self.pendingApprovalShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)


                let interviewStatus = self.dataResponse["status"] as? String ?? ""
                let isProxied = self.dataResponse["is_proxied"] as? Bool ?? false

                if (interviewStatus == "Pending Approval" &&  isProxied) {

                    if self.pendingApprovalShowVideosIcon.alpha != 1.0 {

                        self.pendingApprovalShowVideosIcon.image = UIImage(named: "eyeBorder")

                    } else {

                        let image1 = UIImage(named: "eyeBorder") ?? UIImage()
                        let image2 = UIImage(named: "eyefill") ?? UIImage()//add fill icon here
                        self.pendingApprovalShowVideosIcon.animationDuration = 0.5
                        self.pendingApprovalShowVideosIcon.animationImages = [image1,image2]
                        self.pendingApprovalShowVideosIcon.startAnimating()
                    }



                } else {

                    self.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
                    if self.pendingApprovalShowVideosIcon.isAnimating {
                        print("Still Animating")
                        self.pendingApprovalShowVideosIcon.stopAnimating()
                        self.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
                    }
                }


                self.pendingApprovalReportBtn.tag = tag
                self.pendingApprovalShareBtn.tag = tag
                self.pendingApprovalRatingBtn.tag = tag
                self.pendingApprovalShowVideosBtn.tag = tag



            } else if status == MyinterviewsStatus.pendingResubmission  {

                self.pendingResubmission.isHidden = false

                //Pending Resubmission - Report Action 1
                self.pendingResubmissionReportBtn.isEnabled = false
                self.pendingResubmissionReportIcn.alpha = 0.5
                self.updateReportPermission(button: self.pendingResubmissionReportBtn, imageView: self.pendingResubmissionReportIcn, permissions: permissions, collaborate: isCollaborate, status: status)

                //Pending Resubmission - Share Action 2
                self.pendingResubmissionShareBtn.isEnabled = true
                self.pendingResubmissionShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.pendingResubmissionShareBtn, imageView: self.pendingResubmissionShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Pending Resubmission - Rating Action 3
                self.pendingResubmissionRatingBtn.isEnabled = false
                self.pendingResubmissionRatingIcon.alpha = 0.5
                self.updateReportPermission(button: self.pendingResubmissionRatingBtn, imageView: self.pendingResubmissionRatingIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Show Videos - Action 4
                self.pendingResubmissionShowVideosBtn.isEnabled = showVideoStatus
                self.setAlphaValuesForIcons(imageView: self.pendingResubmissionShowVideosIcon, status: showVideoStatus)
                self.updateReportPermission(button: self.pendingResubmissionShowVideosBtn, imageView: self.pendingResubmissionShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.pendingResubmissionReportBtn.tag = tag
                self.pendingResubmissionShareBtn.tag = tag
                self.pendingResubmissionRatingBtn.tag = tag
                self.pendingResubmissionShowVideosBtn.tag = tag





            } else if(status == MyinterviewsStatus.pendingPayment) {


                self.pendingPayment.isHidden = false

                //Pending Payment - Share Action 1
                self.pendingPaymentShareBtn.isEnabled = true
                self.pendingPaymentShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.pendingPaymentShareBtn, imageView: self.pendingPaymentShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Pending Payment - Pay Action 2
                self.pendingPaymentPayBtn.isEnabled = payStatus
                self.setAlphaValuesForIcons(imageView: self.pendingPaymentPayIcon, status: showVideoStatus)
                self.updateReportPermission(button: self.pendingPaymentPayBtn, imageView: self.pendingPaymentPayIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Pending Payment - Report Action 3
                self.pendingPaymentReportBtn.isEnabled = false
                self.pendingPaymentReportIcon.alpha = 0.5
                self.updateReportPermission(button: self.pendingPaymentReportBtn, imageView: self.pendingPaymentReportIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Pending Payment - Show Videos Action 4
                self.pendingPaymentShowVideosBtn.isEnabled = showVideoStatus
                self.setAlphaValuesForIcons(imageView: self.pendingPaymentShowVideosIcon, status: showVideoStatus)
                self.updateReportPermission(button: self.pendingPaymentShowVideosBtn, imageView: self.pendingPaymentShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.pendingPaymentShareBtn.tag = tag
                self.pendingPaymentPayBtn.tag = tag
                self.pendingPaymentReportBtn.tag = tag
                self.pendingPaymentShowVideosBtn.tag = tag



                let interviewStatus = self.dataResponse["status"] as? String ?? ""
                let isProxied = self.dataResponse["is_proxied"] as? Bool ?? false

                if (interviewStatus == "Pending Payment" &&  isProxied) {

                    if self.pendingPaymentShowVideosIcon.alpha != 1.0 {

                        self.pendingPaymentShowVideosIcon.image = UIImage(named: "eyeBorder")

                    } else {

                        let image1 = UIImage(named: "eyeBorder") ?? UIImage()
                        let image2 = UIImage(named: "eyefill") ?? UIImage()//add fill icon here
                        self.pendingPaymentShowVideosIcon.animationDuration = 0.5
                        self.pendingPaymentShowVideosIcon.animationImages = [image1,image2]
                        self.pendingPaymentShowVideosIcon.startAnimating()
                    }



                } else {

                    self.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
                    if self.pendingApprovalShowVideosIcon.isAnimating {
                        print("Still Animating")
                        self.pendingApprovalShowVideosIcon.stopAnimating()
                        self.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
                    }
                }





            } else if(status == MyinterviewsStatus.completed) {

                self.completedStack.isHidden = false
                // Completed - Report Action 1
                self.completedReportBtn.isEnabled = true
                self.completedReportIcon.alpha = 1.0
                self.updateReportPermission(button: self.completedReportBtn, imageView: self.completedReportIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                // Completed - Share Action 2
                self.completedShareBtn.isEnabled = true
                self.completedShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.completedShareBtn, imageView: self.completedShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                // Completed - Rating Action 3
                self.completedRatingBtn.isEnabled = true
                self.completedRatingIcon.alpha = 1.0
                self.updateReportPermission(button: self.completedRatingBtn, imageView: self.completedRatingIcon, permissions: permissions, collaborate: isCollaborate, status: status)



                // Completed - Analytics Action 4
                self.completedAnalyticsBtn.isEnabled = true
                self.completedAnalyticsIcon.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.completedAnalyticsBtn, imageView: self.completedAnalyticsIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.completedReportBtn.tag = tag
                self.completedShareBtn.tag = tag
                self.completedRatingBtn.tag = tag
                self.completedAnalyticsBtn.tag = tag

                print("========dataResponse=========")
                if let interviewerRating = self.dataResponse["interviewer_rating"] as? [String : Any] {

                    let ratingPresent = interviewerRating["rating_present"] as? Bool ?? false

                    if !ratingPresent {
                        if self.completedRatingIcon.alpha != 1.0 {
                            self.completedRatingIcon.image = UIImage(named: "star_border")
                        } else {


                        let image1 = UIImage(named: "star_border") ?? UIImage()
                        let image2 = UIImage(named: "star_fill") ?? UIImage()//add fill icon here
                        self.completedRatingIcon.animationDuration = 0.5
                        self.completedRatingIcon.animationImages = [image1,image2]
                           self.completedRatingIcon.startAnimating()
                        }
                    } else {
                        if self.completedRatingIcon.isAnimating {
                            self.completedRatingIcon.stopAnimating()
                            self.completedRatingIcon.image = UIImage(named: "star")
                        }
                    }


                }
                
                let interviewAccess = self.dataResponse["interview_access"] as? Bool ?? false

                if interviewAccess {
                    if self.completedShareIcon.alpha != 1.0 {
                        self.completedShareIcon.image = UIImage(named: "shareborder")
                    } else {
                    let image1 = UIImage(named: "shareborder") ?? UIImage()
                    let image2 = UIImage(named: "sharefill") ?? UIImage()//add fill icon here
                    self.completedShareIcon.animationDuration = 0.5
                    self.completedShareIcon.animationImages = [image1,image2]
                    self.completedShareIcon.startAnimating()
                    }
                } else {

                    if self.completedShareIcon.isAnimating {
                        self.completedShareIcon.stopAnimating()
                        self.completedShareIcon.image = UIImage(named: "share")
                    }

                }
 
                let analyticsStatus = self.dataResponse["analytics_completed"] as? Bool ?? false
                
                if analyticsStatus {
                    if self.completedAnalyticsIcon.alpha != 1.0 {
                        self.completedAnalyticsIcon.image = UIImage(named: "analytics")
                    } else {
                    let image1 = UIImage(named: "analytics") ?? UIImage()
                    let image2 = UIImage(named: "analyticsFill") ?? UIImage()//add fill icon here
                    self.completedAnalyticsIcon.animationDuration = 0.5
                    self.completedAnalyticsIcon.animationImages = [image1,image2]
                    self.completedAnalyticsIcon.startAnimating()
                    }
                } else {
                    if self.completedAnalyticsIcon.isAnimating {
                        self.completedAnalyticsIcon.stopAnimating()
                        self.completedAnalyticsIcon.image = UIImage(named: "analytics")
                    }
                }


            } else if status == MyinterviewsStatus.cancelled {

                self.cancelledStack.isHidden = false
                // Cancelled - Reason Action 1
                self.canceledReasonBtn.isEnabled = true
                self.canceledReasonIcon.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.canceledReasonBtn, imageView: self.canceledReasonIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                // Cancelled - Pay Action 2
                self.canceledPayBtn.isEnabled = payStatus
                self.setAlphaValuesForIcons(imageView: self.canceledPayIcon, status: payStatus)
                self.updateReportPermission(button: self.canceledPayBtn, imageView: self.canceledPayIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // Cancelled - WithDraw Action 3
                self.canceldWithdrawBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.canceldWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.canceldWithdrawBtn, imageView: self.canceldWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Cancelled - Show Videos Action 4
                self.canceldShowVideosBtn.isEnabled = false
                self.canceldShowVideosIcon.alpha = 0.5
                self.updateReportPermission(button: self.canceldShowVideosBtn, imageView: self.canceldShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.canceledReasonBtn.tag = tag
                self.canceledPayBtn.tag = tag
                self.canceldWithdrawBtn.tag = tag
                self.canceldShowVideosBtn.tag = tag



            } else if(status == MyinterviewsStatus.waitingOnCandidate) {

                self.waitingOnCandidate.isHidden = false

                // WOC - Availabilty Action 1
                self.wocAvailabityBtn.isEnabled = true
                self.wocAvailabityIcon.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.wocAvailabityBtn, imageView: self.wocAvailabityIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOC - Withdraw Action 2
                self.wocWithdrawBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.wocWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.wocWithdrawBtn, imageView: self.wocWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOC - Share Action 3
                self.wocShareBtn.isEnabled = true
                self.wocShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.wocShareBtn, imageView: self.wocShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOC - join video Action 4
                self.wocJoinVideoBtn.isEnabled = false //By Default
                self.wocJoinVideoIcon.alpha = 0.5 //By Default
               // self.updateReportPermission(button: self.wocJoinVideoBtn, imageView: self.wocJoinVideoIcon, permissions: permissions, collaborate: isCollaborate, status: status)
            } else if status == MyinterviewsStatus.waitingOnInterviewer {

                self.waitingOnInterview.isHidden = false
                // WOI - Availabilty Action 1
                self.woiAvailabityBtn.isEnabled = true
                self.woiAvailabityIcon.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.woiAvailabityBtn, imageView: self.woiAvailabityIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOI - Withdraw Action 2
                self.woiWithdrawBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.woiWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.woiWithdrawBtn, imageView: self.woiWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOI - Share Action 3
                self.woiShareBtn.isEnabled = true
                self.woiShareIcon.alpha = 1.0
                self.updateSharePermission(button: self.woiShareBtn, imageView: self.woiShareIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                // WOI - join video Action 4
                self.woiJoinVideoBtn.isEnabled = false //By Default
                self.woiJoinVideoIcon.alpha = 0.5 //By Default
               // self.updateReportPermission(button: self.woiJoinVideoBtn, imageView: self.woiJoinVideoIcon, permissions: permissions, collaborate: isCollaborate, status: status)

            } else if (status == MyinterviewsStatus.noShow && reason == "") {

                self.noShowStack.isHidden = false
                //No Show - Reason Action 1
                self.noshowReasonBtn.isEnabled = false
                self.noshowReasonIcon.alpha = 0.5
                self.updateCloseInterviewPermission(button: self.noshowReasonBtn, imageView: self.noshowReasonIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //No Show - Pay Action 2
                self.noshowPayBtn.isEnabled = payStatus
                self.setAlphaValuesForIcons(imageView: self.noshowPayIcon, status: payStatus)
                self.updateReportPermission(button: self.noshowPayBtn, imageView: self.noshowPayIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //No Show - Withdraw Action 3
                self.noshowWithdraBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.noshowWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.noshowWithdraBtn, imageView: self.noshowWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                //No Show - Show Videos - Action 4
                self.noshowShowVideosBtn.isEnabled = true
                self.noshowShowVideosIcon.alpha = 1.0
                self.updateReportPermission(button: self.noshowShowVideosBtn, imageView: self.noshowShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.noshowReasonBtn.tag = tag
                self.noshowPayBtn.tag = tag
                self.noshowWithdraBtn.tag = tag
                self.noshowShowVideosBtn.tag = tag

            
                if self.noshowShowVideosIcon.alpha != 1.0 {
                    self.noshowShowVideosIcon.image = UIImage(named: "eyeBorder")
                }else {
                let image1 = UIImage(named: "eyeBorder") ?? UIImage()
                let image2 = UIImage(named: "eyefill") ?? UIImage()//add fill icon here
                self.noshowShowVideosIcon.animationDuration = 0.5
                self.noshowShowVideosIcon.animationImages = [image1,image2]
                self.noshowShowVideosIcon.startAnimating()
                }


            }  else if (status == MyinterviewsStatus.incomplete) {

                self.incompleteStack.isHidden = false

                //Incomplete - Reason Action 1
                self.incompleteReasonBtn.isEnabled = false
                self.incompleteReasonIcon.alpha = 0.5
                self.updateCloseInterviewPermission(button: self.incompleteReasonBtn, imageView: self.incompleteReasonIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Incomplete - Pay Action 2
                self.incompletePayBtn.isEnabled = payStatus
                self.setAlphaValuesForIcons(imageView: self.incompletePayIcon, status: payStatus)
                self.updateReportPermission(button: self.incompletePayBtn, imageView: self.incompletePayIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //Incomplete - Withdraw Action 3
                self.incompleteWithdraBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.incompleteWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.incompleteWithdraBtn, imageView: self.incompleteWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                //No Show - Show Videos - Action 4
                self.incompleteShowVideosBtn.isEnabled = true
                self.incompleteShowVideosIcon.alpha = 1.0
                self.updateReportPermission(button: self.incompleteShowVideosBtn, imageView: self.incompleteShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                self.incompleteReasonBtn.tag = tag
                self.incompletePayBtn.tag = tag
                self.incompleteWithdraBtn.tag = tag
                self.incompleteShowVideosBtn.tag = tag



            } else if(status == MyinterviewsStatus.noShow && reason != "" ) {

                self.noShowStack.isHidden = false

                //No Show - Reason Action 1
                self.noshowReasonBtn.isEnabled = true
                self.noshowReasonIcon.alpha = 1.0
                self.updateCloseInterviewPermission(button: self.noshowReasonBtn, imageView: self.noshowReasonIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //No Show - Pay Action 2
                self.noshowPayBtn.isEnabled = payStatus
                self.setAlphaValuesForIcons(imageView: self.noshowPayIcon, status: payStatus)
                self.updateReportPermission(button: self.noshowPayBtn, imageView: self.noshowPayIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                //No Show - Withdraw Action 3
                self.noshowWithdraBtn.isEnabled = withdrawStatus
                self.setAlphaValuesForIcons(imageView: self.noshowWithdrawIcon, status: withdrawStatus)
                self.updateWithdrawPermission(button: self.noshowWithdraBtn, imageView: self.noshowWithdrawIcon, permissions: permissions, collaborate: isCollaborate, status: status)

                //No Show - Show Videos - Action 4
                self.noshowShowVideosBtn.isEnabled = true
                self.noshowShowVideosIcon.alpha = 1.0
                self.updateReportPermission(button: self.noshowShowVideosBtn, imageView: self.noshowShowVideosIcon, permissions: permissions, collaborate: isCollaborate, status: status)
                self.noshowReasonBtn.tag = tag
                              self.noshowPayBtn.tag = tag
                              self.noshowWithdraBtn.tag = tag
                              self.noshowShowVideosBtn.tag = tag
                
                if self.noshowShowVideosIcon.alpha != 1.0 {
                    self.noshowShowVideosIcon.image = UIImage(named: "eyeBorder")
                }else {
                let image1 = UIImage(named: "eyeBorder") ?? UIImage()
                 let image2 = UIImage(named: "eyefill") ?? UIImage()//add fill icon here
                 self.noshowShowVideosIcon.animationDuration = 0.5
                 self.noshowShowVideosIcon.animationImages = [image1,image2]
                 self.noshowShowVideosIcon.startAnimating()
                }
                
            }

        }
    }

    // MARK:- Share (Permissions)
    func updateSharePermission(button : UIButton, imageView : UIImageView, permissions : [String : Any], collaborate : Bool, status : String) {

        let interviewEdit = permissions[ContributorKeys.interviewEdit] as? Int ?? 0
        if collaborate {
            if button.isEnabled {
                if(!interviewEdit.boolValue) {
                    button.isEnabled = false
                    imageView.alpha = 0.5
                } else {
                    button.isEnabled = true
                    imageView.alpha = 1.0
                }
            }
        }
    }

    // MARK:- WithDraw (Permissions)
    func updateWithdrawPermission(button : UIButton, imageView : UIImageView, permissions : [String : Any], collaborate : Bool, status : String) {

        let candidateEdit = permissions[ContributorKeys.candidateEdit] as? Int ?? 0
        if collaborate {
            if button.isEnabled {
                if !candidateEdit.boolValue {
                    button.isEnabled = false
                    imageView.alpha = 0.5
                } else {
                    button.isEnabled = true
                    imageView.alpha = 1.0
                }
            }
        }
    }

    // MARK:- Edit - Close - Analytics - Availabity (Permissions)
    func updateCloseInterviewPermission(button : UIButton, imageView : UIImageView, permissions : [String : Any], collaborate : Bool, status : String) {

        let candidateEdit = permissions[ContributorKeys.candidateEdit] as? Int ?? 0
        let candidateView = permissions[ContributorKeys.candidateView] as? Int ?? 0

        let interviewEdit = permissions[ContributorKeys.interviewEdit] as? Int ?? 0
        let interviewView = permissions[ContributorKeys.interviewView] as? Int ?? 0

        if collaborate {
            if button.isEnabled {

                if(!candidateView.boolValue && !candidateEdit.boolValue && !interviewView.boolValue && !interviewEdit.boolValue) {
                    button.isEnabled = false
                    imageView.alpha = 0.5
                } else {
                    button.isEnabled = true
                    imageView.alpha = 1.0
                }
            }
        }
    }

    // MARK:- Pay - Rating - Report - Join Video - Show Video (Permissions)
    func updateReportPermission(button : UIButton, imageView : UIImageView, permissions : [String : Any], collaborate : Bool, status : String) {

        let interviewEdit = permissions[ContributorKeys.interviewEdit] as? Int ?? 0
        let interviewView = permissions[ContributorKeys.interviewView] as? Int ?? 0

        if collaborate {
            if button.isEnabled {
                if(!interviewView.boolValue && !interviewEdit.boolValue){
                    button.isEnabled = false
                    imageView.alpha = 0.5
                }
            }
        }
    }
}
