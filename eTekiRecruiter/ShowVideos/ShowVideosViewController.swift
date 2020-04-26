//
//  ShowVideosViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 04/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import AVKit

class ShowVideosViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var noDataLabel: UILabel!
    var videosArray = [String]()
    var interviewCode = ""
    @IBOutlet weak var videosTableView: UITableView!
    
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        if !interviewCode.isEmpty {
            self.showSpinner()
            self.getVideos()
        }
    }
    
    func getVideos() {
        
        candidatesAPI.getInterviewVideos(candidateManger: CandidatesManager(interviewCode: self.interviewCode)) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
                
            } else {
                
                if let videos = response?["videos"] as? [Dictionary<String,Any>] {
                    
                    if self.videosArray.count > 0 {
                        self.videosArray.removeAll()
                    }
                    
                    for dict in videos {
                        if let videoURL = dict["archive_url"] as? String {
                            self.videosArray.append(videoURL)
                        }
                    }
                } else {
                    print("Unable to parse videos")
                }
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if self.videosArray.count == 0 {
                        self.videosTableView.isHidden = true
                        self.noDataLabel.isHidden = false
                    } else {
                        self.videosTableView.isHidden = false
                        self.noDataLabel.isHidden = true
                        self.videosTableView.reloadData()
                    }
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == videosTableView {
            let urlString = self.videosArray[indexPath.row]
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
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == videosTableView {
            return 60
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == videosTableView {
            
            return videosArray.count
            
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = videosTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.videosTableViewCell, for: indexPath) as! VideosTableViewCell
        cell.videoLabel.text = "Video \(indexPath.row + 1)"
        cell.videoLabel.bold(size: 18)
        return cell
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
