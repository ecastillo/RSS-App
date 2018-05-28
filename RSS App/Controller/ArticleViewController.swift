//
//  ArticleViewController.swift
//  RSS App
//
//  Created by Eric Castillo on 5/14/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import SwiftSoup
import Foundation
import FeedKit
import DateToolsSwift
import SubviewAttachingTextView
import DTCoreText

class ArticleViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {

    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bodyContent: ArticleAttributedTextContentView!
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("article url abs: \(article.url?.absoluteURL)")
        
        articleTitle.text = article.title
        featuredImage.sd_setImage(with: article.featuredImageURL, placeholderImage: nil)
        if let url = article.url {
            let domain = url.host?.replacingOccurrences(of: "^www\\.*", with: "", options: .regularExpression)
            website.setTitle(domain, for: .normal)
        }
        date.text = article.date?.timeAgoSinceNow
        
        if let html = article.content {
            let data = html.data(using: .utf8)
            let defaultStyleSheet = DTCSSStylesheet(styleBlock: "br{display: none}")
            let defaultFontFamily = UIFont.systemFont(ofSize: 16).familyName
            let attrString = NSAttributedString(htmlData: data, options:[DTUseiOS6Attributes: true, DTDefaultStyleSheet: defaultStyleSheet, DTDefaultFontFamily: defaultFontFamily, DTDefaultFontSize: 16, DTDefaultLineHeightMultiplier: 1.4], documentAttributes:nil)
            let muteAttString = NSMutableAttributedString(attributedString: attrString!)
            
            bodyContent.shouldDrawImages = false
            bodyContent.delegate = self
            bodyContent.attributedString = muteAttString
        }
    }

    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        let svc = SFSafariViewController(url: article.url!)
        self.present(svc, animated: true, completion: nil)
    }
    
    
    //MARK: - Attachment views
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let imageAttachment = attachment as? DTImageTextAttachment {
            print("found an image of original size: \(imageAttachment.originalSize)")
            // if the attachment has a hyperlinkURL then this is currently ignored
            if imageAttachment.originalSize.width > 0 && imageAttachment.originalSize.height > 0  {
                let imageView = DTLazyImageView(frame: frame)
                imageView.delegate = self
                
                // sets the image if there is one
                imageView.image = imageAttachment.image
                
                // url for deferred loading
                imageView.url = imageAttachment.contentURL
                print("imageview first frame width: \(imageView.frame.width)")
                return imageView
            } else {
                imageAttachment.originalSize = CGSize.zero
            }
        } else if let iframeAttachment = attachment as? DTIframeTextAttachment {
            print("found an iframe of original size: \(iframeAttachment.originalSize)")
            if iframeAttachment.originalSize.width > 0 && iframeAttachment.originalSize.height > 0  {
                // iframe has a height and width, so resize it to fit the screen
                let aspectRatio = iframeAttachment.originalSize.width / iframeAttachment.originalSize.height
                iframeAttachment.displaySize = CGSize(width: bodyContent.frame.width, height: bodyContent.frame.width / aspectRatio)
                let videoView = DTWebVideoView(frame: frame)
                videoView.attachment = iframeAttachment
                return videoView
            } else {
                // iframe doesn't have both height and width, so set originalSize to zero to prevent it from displaying
                iframeAttachment.originalSize = CGSize.zero
            }
        }
        
        return nil
    }
    
    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        print(bodyContent.frame.width)
        lazyImageView.backgroundColor = UIColor.red
        let url = lazyImageView.url
        let pred = NSPredicate(format: "contentURL == %@", url! as CVarArg)
        var didUpdate = false
        
        // update all attachments that match this URL (possibly multiple images with same size)
        for case let oneAttachment as DTTextAttachment in bodyContent.layoutFrame.textAttachments(with: pred) {
            // update attachments that have no original size, that also sets the display size
            print(oneAttachment.contentURL)
            let aspectRatio = size.width / size.height
            oneAttachment.displaySize = CGSize(width: bodyContent.frame.width, height: bodyContent.frame.width / aspectRatio) //imageSize
            didUpdate = true
        }
        if didUpdate {
            // layout might have changed due to image sizes
            // do it on next run loop because a layout pass might be going on
            DispatchQueue.main.async {
                self.bodyContent.layouter = nil // Needed to display image size correctly
                self.bodyContent.relayoutText()
            }
        }
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewForLink url: URL!, identifier: String!, frame: CGRect) -> UIView! {
        if !frame.height.isNaN {
            let linkButton = DTLinkButton(frame: frame)
            linkButton.url = url
            print(url.relativeString)
            print(url.scheme)
            if url.scheme != nil {
                linkButton.url = url
            } else {
                linkButton.url = URL(string: url.absoluteString, relativeTo: article.url?.absoluteURL)
            }
            linkButton.minimumHitSize = CGSize(width: 25, height: 25)
            linkButton.addTarget(self, action: #selector(openLink(_:)), for: .touchUpInside)
            return linkButton
        }
        
        return nil
    }
    
    @objc func openLink(_ sender: DTLinkButton) {
        print(sender.url)
        let svc = SFSafariViewController(url: sender.url)
        self.present(svc, animated: true, completion: nil)
    }
    
    
    override func viewWillLayoutSubviews() {
        print("view will layout subviews")
    
        bodyContent.layouter = nil
        bodyContent.relayoutText()
    }

}


//MARK: - Extensions

extension String {
    func convertHtml() -> NSMutableAttributedString{
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch{
            return NSMutableAttributedString()
        }
    }
}



extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        print("new image width: \(self.size.width*scale)")
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func resizeImage(size: CGFloat) -> UIImage {
        let newSize = CGSize(width: size, height: size)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}



extension String {
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
