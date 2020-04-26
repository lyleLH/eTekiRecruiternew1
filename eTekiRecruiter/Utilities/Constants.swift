//
//  Constants.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 11/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

let applicationId = "eTekiRecuiter"
let None = "None"
let Yes = "Yes"
let No = "No"

struct AppTheme {
    static let brandColor =  UIColor(red: 68.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    static let flagColor =  UIColor(red: 243.0/255.0, green: 183.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    static let borderColor = UIColor(red: 64.0/255.0, green: 189.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    static let appBackgroundColor =  UIColor(red: 242.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let fieldsBorderColor = UIColor(red: 183.0/255.0, green: 196.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let statusBarDefaultColor =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let statusBarHack =  UIColor(red: 242.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 0.5)
    static let containerBorderColor = UIColor(red: 209.0/255.0, green: 218.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    static let shadowColor = UIColor(red: 235.0/255, green: 242.0/255, blue: 245.0/255, alpha: 0.61)
    static let placeHolderColor = UIColor(red: 57.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 0.3)
    static let textColor = UIColor(red: 57.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 1.0)

    static let contributorPermissionsTextColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    static let contributorPermissionsUncheckColor = UIColor(red: 141.0/255.0, green: 149.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    static let interViewerCancelledColor = UIColor(red: 241.0/255.0, green: 72.0/255.0, blue: 91.0/255.0, alpha: 1.0)
    static let interViewCompletedColor = UIColor(red: 58.0/255.0, green: 196.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    static let interViewPendingColor = UIColor(red: 253.0/255.0, green: 143.0/255.0, blue: 82.0/255.0, alpha: 1.0)
}

struct APPFonts {
    static let fontFamilyName = "HelveticaLTStd"
    static let romanFont = "HelveticaLTStd-Roman"
    static let boldFont = "HelveticaLTStd-Bold"
    static let lightFont = "HelveticaLTStd-Light"
}

struct APPColors {
    static let reportViewBarColor1 = UIColor(red: 227.0/255.0, green: 175.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    static let reportViewBarColor2 = UIColor(red: 235.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
}

struct APIMethods {
   static let get = "GET"
   static let post = "POST"
   static let put = "PUT"
}

struct ErrorHandler {
    static let tokenExpired = "Authentication token expired."
}

struct eTekiAWSSupport {
   static let supportedTypes = ["application/vnd","text/plain","application/pdf"]
   static let supportedDocs = ["pdf","docx","doc","txt","rtf","odt"]
    static let documentTypes = ["com.microsoft.word.doc","public.text","public.rtf","com.adobe.pdf","public.composite-content"]
}

struct DeviceDetails {
    static let deviceID = "device-id"
    static let deviceType = "device-type"
    static let deviceUUID = UIDevice.current.identifierForVendor!.uuidString
    static let deviceToken = "device-token"
}

struct TextFieldConstants {
    static let ACCEPTABLECHARACTERS = "0123456789"
}

struct Formats {
    static let date_monthFormat = "dd-MMM-yyyy"
    static let dateFormat_withoutMonth = "dd-MM-yyyy"
    static let reverseDateFormat = "yyyy-MM-dd"
    static let dateFormat = "dd-MMMM-yyyy"
    static let time_12hours_format = "hh:mm a"
    static let time_24hours_format = "HH:mm"
    static let dateAndtimeFormat = "dd-MM-yyyy HH:mm"
    static let date_timeFormat = "dd-MMMM-yyyy hh:mm a"
    static let dateMonthAndTimeFormat = "dd-MMMM-yyyy HH:mm"
    static let dateWithTimeZone = "yyyy-MM-dd'T'HH:mm:ssZ"
}
//Screen Size constants
struct ScreenSize {
    static let width                = UIScreen.main.bounds.size.width
    static let height               = UIScreen.main.bounds.size.height
    static let maxLength            = max(ScreenSize.width, ScreenSize.height)
    static let minLength            = min(ScreenSize.width, ScreenSize.height)
}

//Screen Height constants
struct DeviceHeight {
    static let Inches_3_5 = 480.0 as CGFloat
    static let Inches_4 = 568.0 as CGFloat
    static let Inches_4_7 = 667.0 as CGFloat
    static let Inches_5_5 = 736.0 as CGFloat
}

struct CellIdentifiers {
    static let skillCollectionViewCell = "SkillCollectionViewCell"
    static let menuTableViewCell = "MenuTableViewCell"
    static let filterViewCell = "FilterViewCell"
    static let dashBoardTableViewCell = "DashBoardTableViewCell"
    static let profileCollectionViewCell = "ProfileCollectionViewCell"
    static let generalInfoTableViewCell = "GeneralInfoTableViewCell"
    static let searchTableViewCell = "SearchCell"
    static let socialLinksTableViewCell = "SocialLinksTableViewCell"
    static let jobDetailsCell = "JobDetailsCell"
    static let moreActionsCell = "MoreActionsCell"
    static let candidateViewCell = "CandidateViewCell"
    static let candidateDetailsCell = "DetailsTableViewCell"
    static let candidateAvailibilities = "cellAvailable"
    static let candidateHeader = "header"
    static let candidateInterViews = "interview"
    static let reportCollectionViewCell = "ReportCollectionViewCell"
    static let videosTableViewCell = "VideosTableViewCell"
    static let skillsHeader = "skillsHeader"
    static let skillsDetails = "skillsDetails"
    static let skillsNoData = "skillsNoData"
    static let codeHeader = "codeHeader"
    static let codeData = "codeData"
    static let reportViewImagesCell = "ImagesCollectionViewCell"
    static let audiosTableViewCell = "AudioTableViewCell"
    static let feedbackTableViewCell = "CommentsCell"
    static let interviewers = "interviews"
    static let profile = "profile"
    static let details = "details"
    static let borderlabel = "borderlabel"
    static let content = "content"

}

//StoryBoard Segue Constants
struct StoryboardSegueIdentifiers {
    static let loginToDashboard                 = "LoginToDashboardSegue"
    static let loginToResendConfirmation        = "LoginInToResendConfirmationLinkSegue"
    static let loginToForgotPasswordSegue       = "LoginToForgotPasswordSegue"
    static let dashBoardToMoreViewActions       = "DashBoardToMoreViewActions"
    static let moreToJobDetails                 = "MoreToJobDetails"
    static let moreToCreateJob                  = "MoreToCreateJob"
    static let signIntoCustomAlert              = "SignIntoCustomAlert"
    static let forgotPasswordToCustomMessage              = "ForgotPasswordToCustomMessage"
    static let loginInToResendConfirmationLinkSegue       = "LoginInToResendConfirmationLinkSegue"
    static let resendConfirmationToCustomMessage              = "ResendConfirmationToCustomMessage"
    static let linkedInToDashboard              = "LinkedInToDashboard"
    static let facebookToDashboard              = "FacebookToDashboard"
    static let verifyOTPtoCustomMessage              = "VerifyOTPToCustomMessage"
    static let dashboardToCreateJob             = "dashboardToCreateJob"
    static let menuToDashboard                  = "MenuToDashBoard"
    static let menuToProfile                    = "MenuToProfile"
    static let menuToEsclationsVC               = "menuToEscalations"
    static let menuToPayments                   = "MenuToPayments"
    static let menuToLogin                      = "MenuToLogin"
    static let profileToPrimaryInfo             = "ProfileToPrimaryInfo"
    static let profileToChangePassword          = "ProfileToChangePassword"
    static let createJobToLangaugeSearch        = "CreateJobToLangaugeSearch"
    static let createJobToAreaExpertise         = "CreateJobToAreaOfExpertise"
    static let createJobToSuggestSkill         = "CreateJobToSuggestSkill"
    static let createJobToDashboard            = "CreateJobToDashboard"
    static let moreToEditContributors          = "MoreToEditContributors"
    static let dashboardToDatePicker           = "DashboardToDatePicker"
    static let dashboardToCustomMessage        = "DashboardToCustomMessage"
    static let analyticsToCustomMessage        = "AnalyticsToCustomMessage"
    static let dashboardToFilters              = "DashboardToFilters"
    static let dashboardToCandidates           = "DashboardToCandidates"
    static let candidatesToAddCandidate        = "CandidatesToAddCandidate"
    static let createJobToCountrySearch        = "CreateJobToCountrySearch"
    static let addressToCountriesSearch        = "AddressToCountriesSearch"
    static let addCandidateToTimeZone          = "AddCandidateToTimeZone"
    static let moreToEditCandidate             = "MoreToEditCandidate"
    static let addCandidateToDashboard         = "AddCandidateToDashboard"
    static let moreToWithdrawn                 = "MoreToWithDrawn"
    static let candidateToDetails              = "CandidateToDetails"
    static let toAddNewCandidate                = "ToAddNewCandidate"
    static let moreToAnalytics                  = "MoreToAnalytics"
    static let candidateDetailsToEditCandidate = "CandidateDetailsToEditCandidate"
    static let dashboardToCandidateAvailabilty = "DashboardToCandidateAvailabilty"
    static let provideAvailabiltyToTimeZones = "ProvideAvailabiltyToTimeZones"
    static let candidateToSearch = "CandidateToSearch"
    static let addCandidateToCandidateOwner = "AddCandidateToCandidateOwner"
    static let provideAvailibiltyToCustomMessage = "ProvideAvailibiltyToCustomMessage"
    static let moreToCandidateAvailabilty   = "MoreToCandidateAvailabilty"
    static let moreToMatchedInterviews = "MoreToMatchedInterviews"
    static let matchedInterviewsToInterViewerProfile = "MatchedInterviewsToInterviewerProfile"
    static let contributorsToCustomMessage = "ContributorsToCustomMessage"
    static let dashboardToContributorPermissions = "DashboardToContributorPermissions"
    static let createJobToContributorSettings = "CreateJobToContributors"
    static let contributorSettingsToDashboard = "ContributorSettingsToDashboard"
    static let shareInterviewToCustomAlert = "shareInterviewToCustomAlert"
    static let dashboardToWithdrawn = "dashboardToWithdrawn"
    static let dashboardToReason = "dashboardToReason"
    static let CustomAlertToWithdrawn = "CustomAlertToWithdrawn"
    static let dashboardTointerviewRatingView = "dashboardTointerviewRatingView"
    static let dashboardToAnlaytics = "dashboardToAnlaytics"
    static let myInterviewsToShare = "InterviewsToShare"
    static let customAlertToCancelInterview = "customAlertToCancelInterview"
    static let customAlertToCancelCustomInterview = "customAlertToCancelCustomInterview"
    static let cancelCustomToCancelInterview = "cancelCustomToCancelInterview"
    static let cancelInterviewToConfirmation = "cancelInterviewToConfirmation"
    static let cancelConfirmToWithdrawn = "cancelConfirmToWithdrawn"
    static let dashboardToNoshow = "dashboardToNoshow"
    static let dashboardToReportView = "DashboardToReportView"
    static let dashboardToShowVideos = "DashboardToShowVideos"

    static let interviewsToRating = "InterviewsToRating"
    static let reportViewToWithdrawn = "reportViewToWithdrawn"
    static let reportViewToShare = "reportViewToShare"
    static let reportViewToPictureId = "reportViewToPictureId"
    static let reportToCustomPopup = "ReportToCustomPopup"
    static let reportToFeedback = "reportToFeedback"
    static let feedbackToWithdrawn = "feedbackToWithdrawn"
    static let reportToImagesView = "reportViewToImagesScroll"
    
}

// Storyboard Identifiers
struct StoryboardIdentifiers {
    static let signInSegue = "SignInSegue"
    static let moreActionsViewController = "MoreActionsViewController"
    static let customAlertViewController = "CustomAlertViewController"
    static let jobDetailsViewController = "JobDetailsViewController"
    static let dropDownViewController = "DropDownViewController"
    static let forgotPasswordViewController = "DropDownViewController"
    static let customPopOverController = "customPopoverViewController"
    static let candidatesViewController = "CandidatesViewController"
    static let signInViewController = "SignInViewController"
    static let dashboardViewController = "DashboardViewController"
    static let addCandidateViewController = "AddCandidateViewController"
    static let signInToLinkedInWebView = "SignInToLinkedInWebView"
}

struct Candidates {
    static let dateExpired = "Job due date expired"
}

struct DashBoardScreenFonts {
    static let segementTitleColor = UIColor(red: 40.0/255.0, green: 60.0/255.0, blue: 83.0/255.0, alpha: 1.0)
}

struct CustomAlertFonts {
    static let alertBorderColor = UIColor(red: 209.0/255.0, green: 218.0/255.0, blue: 222.0/255.0, alpha: 1.0)
}

struct CreateJobFonts {
    
    static let selectedBackgoundColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    static let currentSelectedCenterColor = UIColor(red: 68.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    static let selectedOuterCircleStrokeColor = UIColor(red: 209.0/255.0, green: 218.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    static let stepTextColor = UIColor(red: 40.0/255.0, green: 60.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    static let currentSelectedTextColor = UIColor(red: 68.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)
}

struct APIRequestError {
    static let domainErrorCode = -1001
}

struct AnalyticsScreenFonts {
    static let progressStatusColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    static let progressButtonColor = UIColor(red: 89.0/255.0, green: 148.0/255.0, blue: 37.0/255.0, alpha: 1.0)

}

struct Assets {
    static let dasboard = "dashboard-white"
    static let dasboardBlue = "dashboardBlue"

    static let profile =  "profile-white"
    static let profileBlue = "userBlue"

    static let payment =  "payment-white"
    static let logout =   "logout-white"
    static let logoutBlue =   "logoutBlue"
    
    static let primaryIcon =   "primary_icon"
    static let addressIcon =   "address_icon"
    static let keyIcon =   "key"
    static let companyIcon =   "company"
    static let mailIcon =   "mail_icon"
    static let barcodeIcon =   "barcode"
    static let blueBadge = "BlueBadge"
    static let orangeBadge = "OrangeBadge"
    static let noImage = "NoImage"
}

struct ContributorKeys {
    static let jobNotify = "Job Notify"
    static let candidateNotify = "Candidate Notify"
    static let interViewNotify = "Interview Notify"
    static let jobEdit = "Job Edit"
    static let candidateEdit = "Candidate Edit"
    static let interviewEdit = "Interview Edit"
    static let jobView = "Job View"
    static let candidateView = "Candidate View"
    static let interviewView = "Interview View"
}

struct MyinterviewsStatus {
    static let myInterviews = "My Interviews"
    static let contributorInterviews = "Contributor Interviews"
    static let pendingReport = "Pending Report"
    static let pendingSubmission = "Pending Submission"
    static let pendingApproval = "Pending Approval"
    static let pendingResubmission = "Pending Resubmission"
    static let pendingPayment = "Pending Payment"
    static let completed = "Completed"
    static let priorHour = "Prior 1Hour"
    static let cancelled = "Cancelled"
    static let incomplete = "Incomplete"
    static let noShow = "No Show"
    static let lateCancellation = "Late Cancellation"
    static let waitingOnCandidate = "Waiting on Candidate"
    static let waitingOnInterviewer = "Waiting on Interviewer"
    static let scheduled = "Scheduled"
    static let inProgress = "In Progress"
    static let candidatePending = "Candidate-Pending"
    static let candidateConfirmed = "Candidate-Confirmed"
    static let interViewerPending = "Interviewer-Pending"
    static let interviewerConfirmed = "Interviewer-Confirmed"
    static let report = "report"
    static let interViewStatusTypes = [myInterviews,contributorInterviews,pendingReport,pendingSubmission,pendingApproval,pendingResubmission,pendingPayment,completed,priorHour,cancelled,incomplete,noShow,lateCancellation,waitingOnCandidate,waitingOnInterviewer,scheduled,inProgress,candidatePending,candidateConfirmed,interViewerPending,interviewerConfirmed]
}

struct MatchedInterviewers {
    static let certified = "Certified"
    static let trained = "Trained"
    static let MatchedInterviewers = "Matched Interviewers"
    static let summary = "Summary"
    static let yearsofExperience = "Years of Experience"
    static let priorInterviewingExperience = "Prior Interviewing Experience"
    static let skills = "Skills"
    static let languages = "Languages"
}
struct Skills {
    static let requiredSkills = "Required Skills"
    static let optionalSkills = "Optional Skills"
    static let noOptionalSkills = "There are no optional skills to display."
    static let noRequiredSkills = "There are no required skills to display."
}

struct RevertReport {
   static let requestEditsAdmin = "Request Edits Admin"
   static let requestEditsRecruiter = "Request Edits Recruiter"
   static let pendingAdminApproval = "Pending Admin Reapproval"
   static let requesEditAdminMessage = "Quality Control is still in progress. Support Team requested the interviewer to update the report. We will provide you the updated report shortly."
   static let requestEditsRecruiterMessage = "Your Request for revert the report is still in progress. Please wait"
   static let pendingAdminApprovalMessage = "Quality Control is still in progress. Support Team need to approve the report."
   static let revert = "revert"
    static let addComment = "Add Comment"
}

struct validationMessages {
    static let emailCantBeBlank = "Email can't be blank"
    static let enterValidEmail = "Enter valid email"
}
struct LocalCountry {
    
    static let usstates = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut", "Delaware", "Florida","Georgia","Hawali","Idaho","Illinios","Indiana", "Iowa", "Kansas","Kentucky", "Louisiana","Maine","Maryland", "Massachusetts","Michigan","Minnesota","Mississippi", "Missouri","Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York","North Carolina","North Dakota","Ohio","Oklahoma", "Oregon","Pennsylvania","Rhode Island", "South Carolina",
                           "South Dakota", "Tennessee", "Texas","Utah","Vermont","Virginia","Washington","West Virginia", "Wisconsin","Wyoming"]
    
    static var timezoneList = [["US/Samoa":"(GMT11:00) American Samoa, Midway Island"],
                               ["US/Hawaii":"(GMT10:00) Hawaii"],
                               ["US/Alaska":"(GMT09:00) Alaska"],
                               ["US/PacificNew":"(GMT08:00) Pacific Time (US & Canada)"],
                               ["US/Mountain":"(GMT07:00) Arizona, Mountain Time (US & Canada)"],
                               ["US/IndianaStarke":"(GMT06:00) Central Time (US & Canada), Mexico City"],
                               ["US/Michigan":"(GMT05:00) Eastern Time (US & Canada), US/Michigan"],
                               ["Chile/Continental":"(GMT04:00) Atlantic Time (Canada), Santiago"],
                               ["Canada/Newfoundland":"(GMT03:30) Newfoundland"],
                               ["Brazil/East":"(GMT03:00) Brasilia, Greenland"],
                               ["Brazil/DeNoronha":"(GMT02:00) MidAtlantic"],
                               ["UTC":"(GMT+00:00) UTC, London, Casablanca"],
                               ["Poland":"(GMT+01:00) Amsterdam, Berlin, Copenhagen, Paris"],
                               ["Europe/Nicosia":"(GMT+02:00) Athens, Harare, Jerusalem"],
                               ["Africa/Asmera":"(GMT+03:00) Kuwait"],
                               ["WSU":"(GMT+04:00) Abu Dhabi, Moscow"],
                               ["Asia/Ashkhabad":"(GMT+05:00) Karachi, Islamabad, Tashkent"],
                               ["Asia/Calcutta":"(GMT+05:30) Chennai, Mumbai, Kolkata"],
                               ["Asia/Thimbu":"(GMT+06:00) Dhaka, Ekaterinburg"],
                               ["Asia/Saigon":"(GMT+07:00) Bangkok, Jakarta"],
                               ["Singapore":"(GMT+08:00) Beijing, Hong Kong, Singapore"],
                               ["ROK":"(GMT+09:00) Seoul, Tokyo"],
                               ["Pacific/Yap":"(GMT+10:00) Melbourne"],
                               ["Pacific/Ponape":"(GMT+11:00) New Caledonia, Vladivostok"],
                               ["NZ":"(GMT+12:00) Auckland, Wellington, Magadan"]] as Array<Dictionary<String,String>>
}
