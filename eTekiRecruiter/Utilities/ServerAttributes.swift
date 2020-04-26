//
//  ServerAttributes.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

struct LinkedInKeys {

    static let clientID = "78s9bw0pex6xwh"
    static let clientSecret = "522uJ4SRhkNxYSxe"
    static let state = "DCEeFWf45A53sdfKef424DCEeFWf45A53sdfKef424"
    static let permissions = ["r_liteprofile", "r_emailaddress"] 
    static let redirectURL = "https://www.eteki.com/"
}

class ServerAttributes {
    public static let interviewer = "Interviewer"
    public static let recruiter = "Recruiter"
    public static let isCandidate = "Candidate"
    public static let isSuperAdmin = "Eteki SuperAdmin"
    public static let addCandidate = "/candidates"
    public static let updateCandidate = "/update_candidate"
    public static let candidate = "/candidate"
    public static let candidates = "/candidates"
    public static let contributorsPath = "/recruiters"
    public static let interviewsPath = "/interviews"
    public static let comments = "/comments"
    public static let candidateAvailabilties = "/candidate_availabilities"
    public static var basePath = "/users"
    public static var profileBasePath = "/profile"
    public static var interViewersPath = "/interviewers"
    public static var smsbasebath = "/sms"
    public static let candidatesBaseBath = "/candidates"
    public static var recruiterBasePath = "/recruiter"
    public static var jobs = "/jobs"
    public static var myInterviews = "/interviews"
    public static var reactivate = "/jobs/reactivate"
    public static var closeJob = "/jobs/close_job"
    public static let signIn = "/sign_in"
    public static let interviewAccess = "/interview_access"
    public static let forgotPassword = "/forgot_password"
    public static let oath = "/oauth_login"
    public static let resendConfirmation = "/resend_confirmation"
    public static let changePassword = "/change_password"
    public static let getProfileDetails = "/get_profile_details"
    public static let resetPasscode = "/reset_recruiter_report_passcode"
    public static let updatePrimaryProfile = "/update_social_links"
    public static let updateCompanyDetails = "/update_company_billing_address"
    public static let updateAddress = "/update_address"
    public static let updateSMS = "/sms_service_update"
    public static let verifyOTP = "/verify_otp"
    public static let resendOTP = "/resend_otp"
    public static let areaOfExpertise = "/list_categories"
    public static let skillsAutoComplete = "/skillset_autocomplete"
    public static let suggestSkills = "/skills/suggest_skill"
    public static let getJobDetails = "/get_details"
    public static let signOut = "/sign_out"
    public static let saveFilters = "/save_search_query"
    public static let getDefaultFilters = "/get_default_filter"
    public static let getCountries = "/countries_list"
    public static let getCandidates = "/candidates"
    public static let getOwners = "/get_job_recruiters_list"
    public static let getJobCandidates = "/get_job_candidates"
    public static let getEmailAvailabilty = "/email_availability"
    public static let getCandidateExistance = "/candidate_existence"
    public static let withdrawCandidate = "/update_withdraw_status"
    public static let getROIStatus = "/get_candidate_roi_details"
    public static let updateROIStatus = "/update_hiring_status"
    public static let getTimeZones = "/time_zone_list"
    public static let matchedInterviews = "/get_matched_interviewers"
    public static let interViewerDetails = "/interviewer_details"
    public static let getContributorPermissions = "/get_recruiter_permissions"
    public static let addPermissionsToRecruiter = "/add_permissons_to_recruiters"
    public static let getCompanyRecruiters = "/get_company_recruiters"
    public static let getInterviews = "/get_interviews"
    public static let getInterviewsWithJob = "/get_job_interviews"
    public static let getCanccellationReason = "/get_cancellation_reason"
    public static let getInterviewerRatingDetails = "/get_interviewer_rating_details"
    public static let getShareDetails = "/list"
    public static let addEmailToShare = "/share"
    public static let deleteEmailFromShare = "/delete"
    public static let rateInterviewer = "/rate_interviewer"
    public static let notifyRecruiter = "/notify_recruiter_interview_sharing"
    public static let cancellationDetails = "/cancellation_details"
    public static let cancel = "/cancel"
    public static let reportView = "/shared_interview_details"
    public static let createComment = "/create_comment"
    public static let inteviewVideos = "/interview_videos"
}

