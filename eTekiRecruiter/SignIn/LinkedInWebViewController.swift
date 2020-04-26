//
//  LinkedInWebViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/03/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import WebKit

class LinkedInWebViewController: BaseViewController , WKNavigationDelegate {

    @IBOutlet weak var wkWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showSpinner()
        wkWebView.navigationDelegate = self
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
        startAuthorization()
        self.navigationItem.title = "LinkedIn Sign In"
    }


    func startAuthorization() {
        let responseType = "code"
        let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let scope = "r_emailaddress,r_liteprofile"
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(LinkedInKeys.clientID)&"
        authorizationURL += "redirect_uri=\(LinkedInKeys.redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"

        if let requestURL = URL(string: authorizationURL) {
            wkWebView.load(URLRequest(url: requestURL))
        }
        wkWebView.allowsBackForwardNavigationGestures = true
    }

    func requestForAccessToken(authorizationCode: String) {

        let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"

        var postParams = "grant_type=\("authorization_code")&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(LinkedInKeys.redirectURL)&"
        postParams += "client_id=\(LinkedInKeys.clientID)&"
        postParams += "client_secret=\(LinkedInKeys.clientSecret)"


        self.httpPostRequest(basePath: accessTokenEndPoint, parameters: postParams, method: APIMethods.post) { (response, errorResponse) in

            if errorResponse != nil {
                self.showBanner(title: errorResponse?.tittle ?? "", withMessage: errorResponse?.message ?? "Server Error", style: .danger)
            } else {
                if let response = response {
                    let accessToken = response["access_token"] as? String ?? ""
                    print(accessToken)
                    UserDefaults.standard.set(accessToken, forKey: "linkedIn_access_token")
                    self.getUserEmailAdderess(accessToken: accessToken)

                }
            }
        }
    }

    func getUserEmailAdderess(accessToken : String) {
        let emailRequestString = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"

        self.httpGetRequest(basePath: emailRequestString, parameters: ["access_token" : accessToken]) { (response, errorResponse) in
            if errorResponse != nil {
                self.showBanner(title: errorResponse?.tittle ?? "", withMessage: errorResponse?.message ?? "Server Error", style: .danger)
            } else {
                if let response = response {

                        if let handle = response["elements"] as? [[String:Any]] {
                            let handler = handle[0]
                            let result = handler["handle~"] as? [String : Any]
                            if let email = result?["emailAddress"] as? String {

                                print(email)

                                self.requestLinkedInProfile(email: email, withAccessToken: accessToken)
                            }
                        }


                }
            }
        }

    }

    func requestLinkedInProfile(email : String, withAccessToken token: String) {

        let emailRequestString = "https://api.linkedin.com/v2/me"

        self.httpGetRequest(basePath: emailRequestString, parameters: ["access_token" : token]) { (response, errorResponse) in
            if errorResponse != nil {
                self.showBanner(title: errorResponse?.tittle ?? "", withMessage: errorResponse?.message ?? "Server Error", style: .danger)
            } else {
                if let response = response {
                    print(response)



                    NotificationCenter.default.post(name: Notification.Name("LinkedInProfileResponse"), object: nil, userInfo: ["LinkedInResponse": response,"email" : email])
                }
            }
        }
    }

    func postRequestURL(inputString : String) -> URLRequest? {
        print("=================== SERVER URL===========\(inputString)")
        guard let serviceUrl = URL(string: inputString) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        return request
    }

    func httpPostRequest(basePath : String, parameters : String ,method : String,completionHandler: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {

        guard var request = self.postRequestURL(inputString: basePath) else {return}
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData

        guard let configuredSession = RequestBuilder.shared.getSession() else {return}

        configuredSession.dataTask(with: request) { (data, response, error) in

            if error != nil {
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: error?.localizedDescription ?? "Unable to reach server, Please check your Network/VPN Settings.", tittle: "")
                completionHandler(nil,errorResponse)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                    if let dictFromJSON = json as? [String:Any] {
                        print(dictFromJSON)
                        completionHandler(dictFromJSON,nil)
                    }
                } catch {
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: error.localizedDescription, tittle: "")
                    completionHandler(nil,errorResponse)
                }
            }
        }.resume()
    }


    func getRequestURL(inputString : String) -> URLRequest? {
        guard let serviceUrl = URL(string: inputString) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        if let token = UserDefaults.standard.value(forKey: "linkedIn_access_token") as? String {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }


        func httpGetRequest(basePath : String, parameters : Dictionary<String,Any> ,completionHandler: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {

            guard let request = self.getRequestURL(inputString: basePath) else {return}


            guard let configuredSession = RequestBuilder.shared.getSession() else {return}

            configuredSession.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    if error?.code == APIRequestError.domainErrorCode {
                        let errorResponse = ErrorResponse(responseCode: false.intValue, message: "Unable to reach server, Please check your Network/VPN Settings.", tittle: "")
                        completionHandler(nil,errorResponse)
                        return
                    }
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictFromJSON = json as? [String:Any] {

                                completionHandler(dictFromJSON,nil)

                        }
                    } catch {
                        let errorResponse = ErrorResponse(responseCode: false.intValue, message: error.localizedDescription, tittle: "LinkedIN")
                        completionHandler(nil,errorResponse)
                    }
                }
            }.resume()
        }


}

extension LinkedInWebViewController {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url
        let urlStr = url?.absoluteString
        print(urlStr ?? "")
        let host = url?.host
        let baseURl = URL(string: LinkedInKeys.redirectURL)


        if let code = url?.queryParameters["code"] {
            self.requestForAccessToken(authorizationCode: code)
        }

        switch host {
        case baseURl?.host:
            decisionHandler(.cancel)
            break
        default:
            decisionHandler(.allow)
            break
        }

        self.removeSpinner()

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true, completion: nil)
        print(error.localizedDescription)
    }


}


extension URL {
    var queryParameters: QueryParameters { return QueryParameters(url: self) }
}

class QueryParameters {
    let queryItems: [URLQueryItem]
    init(url: URL?) {
        queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
        print(queryItems)
    }
    subscript(name: String) -> String? {
        return queryItems.first(where: { $0.name == name })?.value
    }
}
