//
//  ImagesScrollableViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 19/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//
import UIKit

class ImagesScrollableViewController: BaseViewController {
    var frame = CGRect.zero
    var index = 0
    var imagesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
        let viewHeight: CGFloat = self.view.bounds.size.height
        let viewWidth: CGFloat = self.view.bounds.size.width
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        var xPostion: CGFloat = 0
        self.setUpNavigationBar()
        for image in imagesArray {
            let view = UIView(frame: CGRect(x: xPostion, y: 0, width: viewWidth, height: viewHeight))
            xPostion += viewWidth
            let imageView = ImageViewZoom(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100))
            
            imageView.setup()
            imageView.imageScrollViewDelegate = self
            imageView.imageContentMode = .aspectFit
            imageView.initialOffset = .center
            imageView.bounces = false
            
            let tempImageView = UIImageView()
            tempImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "logo_placeholder"))
            imageView.display(image: tempImageView.image ?? UIImage())
            imageView.backgroundColor = AppTheme.appBackgroundColor
            
            view.addSubview(imageView)
            scrollView.addSubview(view)

        }
        scrollView.contentSize = CGSize(width: xPostion, height: viewHeight-100)
        scrollView.contentOffset.x = self.view.frame.size.width * CGFloat(index)
        self.view.addSubview(scrollView)
    }

}

extension ImagesScrollableViewController: ImageViewZoomDelegate {
    func imageScrollViewDidChangeOrientation(imageViewZoom: ImageViewZoom) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}
