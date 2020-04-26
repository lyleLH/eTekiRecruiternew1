//
//  MenuTableViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 11/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class MenuTableViewController: UITableViewController,MenuTableViewModelDelegate {
    
    @IBOutlet var menuTableView: UITableView!
    var viewModel = MenuTableViewModel()
    var vSpinner : UIView?
    var menuList = Array<String>()
    var isNavigatingFrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        menuList = ["DASHBOARD".localized,"PROFILE".localized,"LOGOUT".localized,"Esclations"]

        //"PAYMENTS".localized
        viewModel.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension MenuTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.menuTableViewCell, for: indexPath) as? MenuTableViewCell ?? MenuTableViewCell()
        cell.selectionStyle = .none
        cell.menuTitleLabel.text = menuList[indexPath.row]

        if isNavigatingFrom == cell.menuTitleLabel.text {
            cell.backgroundColor = .white
            cell.menuTitleLabel.textColor = AppTheme.brandColor
        } else {
            cell.backgroundColor = AppTheme.brandColor
            cell.menuTitleLabel.textColor = .white
        }

        switch indexPath.row {
        case 0:
            if isNavigatingFrom == cell.menuTitleLabel.text {
                cell.iConView.image = UIImage(named: Assets.dasboardBlue)
            } else {
                cell.iConView.image = UIImage(named: Assets.dasboard)
            }
            return cell
        case 1:
            if isNavigatingFrom == cell.menuTitleLabel.text {
                cell.iConView.image = UIImage(named: Assets.profileBlue)
            } else {
                cell.iConView.image = UIImage(named: Assets.profile)
            }
            return cell
            
        case 2:

            if isNavigatingFrom == cell.menuTitleLabel.text {
                cell.iConView.image = UIImage(named: Assets.logoutBlue)
            } else {
                cell.iConView.image = UIImage(named: Assets.logout)
            }
            return cell
            
        case 3:

        if isNavigatingFrom == cell.menuTitleLabel.text {
            cell.iConView.image = UIImage(named: Assets.logoutBlue)
        } else {
            cell.iConView.image = UIImage(named: Assets.logout)
        }
        return cell

            
        default: fatalError("Unhandled section \(indexPath.section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.menuToDashboard, sender: self)
        case 1:
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.menuToProfile, sender: self)
            //case 2: //Payments section currently not required.
        //self.performSegue(withIdentifier: StoryboardSegueIdentifiers.menuToPayments, sender: self)
        case 2:
            NotificationCenter.default.post(name: Notification.Name("UserShouldLoggedOut"), object: nil, userInfo: nil)
            self.dismiss(animated: false, completion: nil)
        case 3:
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.menuToEsclationsVC, sender: self)
        default: fatalError("Unhandled section \(indexPath.section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let profileImageView = UIImageView(frame: CGRect(x: 23, y: 0, width: 60, height: 60))
        
        if let profilePic = UserDefaults.standard.object(forKey: "ProfilePic") as? String {
            profileImageView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "NoImage"))
            profileImageView.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
            
            
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        let profileNameLabel = UILabel(frame: CGRect(x: 93, y: 0, width: 120, height: 42))
        profileNameLabel.textAlignment = .left
        profileNameLabel.numberOfLines = 2
        
        if let profileName = UserDefaults.standard.object(forKey: "displayName") as? String {
            profileNameLabel.text = profileName
        }
        
        profileNameLabel.textColor = .white
        profileNameLabel.font = UIFont.appLightFontWith(size: 18.0)

        let roleLabel = UILabel(frame: CGRect(x: 93, y: 32, width: 120, height: 21))
        
        if let role = UserDefaults.standard.object(forKey: "Role") as? String {
            roleLabel.text = role
        }
        roleLabel.textColor = .white
        roleLabel.font = UIFont.appLightFontWith(size: 18.0)
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(roleLabel)
        return view
        
    }
}


extension MenuTableViewController {
    
    func onAPISuccessResponse(response: SignInResponse?) {
        DispatchQueue.main.async {
            if response?.success ?? false {
                self.removeSpinner()
                self.showBanner(title: "", withMessage: "User logged Out", style: .success )
                UserDefaults.standard.set("", forKey: "authentication_token")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
                UIApplication.shared.keyWindow?.rootViewController = signInViewController
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?) {
        DispatchQueue.main.async {
            guard let message = errorResponse?.message else {return}
            self.showBanner(title: "", withMessage: message, style: .danger)
            
        }
    }
    
    func showBanner(title:String, withMessage message:String, style : BannerStyle) {
        if message == "" {
            return
        }
        let banner = GrowingNotificationBanner(title: "", subtitle: message, style: style)
        // banner.backgroundColor = AppTheme.brandColor
        banner.show()
        banner.duration = 2.0
        banner.remove()
    }
    
}

extension MenuTableViewController {
    
    func showSpinner() {
        let spinnerView = UIView(frame: self.view.frame)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        
        
        self.view.addSubview(spinnerView)
        self.view.bringSubviewToFront(spinnerView)
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
