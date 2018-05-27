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
    
    var articleContent = """
                        The Google News app is a reimagining and revamp to the existing Google Newsstand Play app that was previously available via the iOS App Store. It's been entirely overhauled though, with a simple, clean interface that's fairly similar to the look of Apple News with a dedicated navigation bar at the bottom.
                        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTitle.text = article.title
        
        if let url = article.url {
            let domain = url.host?.replacingOccurrences(of: "^www\\.*", with: "", options: .regularExpression)
            website.setTitle(domain, for: .normal)
        }
        
        date.text = article.date?.timeAgoSinceNow
        
        featuredImage.sd_setImage(with: article.featuredImageURL, placeholderImage: nil)
        
        test()
    }

    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        let svc = SFSafariViewController(url: article.url!)
        self.present(svc, animated: true, completion: nil)
    }
    
    func test() {
        if var html = article.content {

            var string = """
                        The Worldwide Developers Conference is just about a week and a half away, and while we've heard some rumors on what we might see in iOS 12 and macOS 10.14, watchOS 5, the next-generation software update for the Apple Watch, remains a total mystery.
                        <br/>

                        <br/>
                        With no idea what to expect, we asked <em>MacRumors</em> readers what new features and tweaks they would most like to see in the watchOS 5 update.
                        <br/>

                        <br/>
                        <img src="http://cdn.macrumors.com/article-new/2018/05/watchos5-800x395.jpg" alt="" width="800" height="395" class="aligncenter size-large wp-image-637612" />
                        <br/>
                        <ul>
                        <br/>
                             <li><strong>Live step count complication</strong> - <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26066451">Breezygirl</a> would like to see Apple add a live step complication that lets you see how many steps you've completed at a glance, rather than just a complication that lets you know how close you've come to hitting your activity ring goal.</li><br>
                        <br/>
                             <li><strong>Third-party watch faces</strong> - Third-party watch faces are highly desired by most Apple Watch owners on the forums, but so far, Apple has kept the Apple Watch locked down to control the design and interface of the device. As <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26066887">Relentless Power</a> suggests, a watch face store that includes a variety of watch faces from third-party developers and companies would be great.</li><br>
                        <br/>
                             <li><strong>Activity app improvements</strong> - Right now, the Activity app requires you to hit your goals each and every day to keep a streak going, which can be difficult at times and allows for no rest. <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26066994">SoYoung</a> would like to be able to set rest days.</li><br>
                        <br/>
                             <li><strong>Workout app improvements</strong> - In the same vein, <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26067372">Rbart</a> is hoping for a better workout app for running that's closer in design to Strava with additional statistics, a complete history, best performances, and more. <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26068192">Honglong1976</a>, meanwhile, would like to see automatic activity detection to alleviate the need to start a workout.</li><br>
                        <br/>
                             <li><strong>Podcasts for Apple Watch</strong> - Multiple <em>MacRumors</em> <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26067031">readers</a> would like to see a dedicated Podcasts app on the Apple Watch for listening to podcasts on the wrist-worn device.</li><br>
                        <br/>
                             <li><strong>Off-wrist Notifications indicator</strong> - <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26066619">Lennyvalentin</a> would like to see the Apple Watch better able to keep track of incoming notifications even when off the wrist, with those notifications still showing up but with an indication to note that they were received while the Apple Watch was idle.</li><br>
                        <br/>
                             <li><strong>Proximity notifications</strong> - There's no way to set the Apple Watch to ping when it goes out of range of the iPhone, a feature <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26068190">Justiny</a> would like to see as a way to keep track of the iPhone and get a reminder if it's left behind.</li><br>
                        <br/>
                             <li><strong>Sleep tracking</strong> - This one is probably a long shot given that Apple suggests people charge their Apple Watches at night, but <em>MacRumors</em> readers would <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26068568">like to see</a> native sleep tracking capabilities.</li><br>
                        <br/>
                             <li><strong>Always-on display</strong> - Given battery constraints, Apple has never implemented an always-on display for the Apple Watch, which is another <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26068960">highly desired feature</a>. The Apple Watch display comes on when the wrist is raised, but it would be nice to have always-on access to the time as is possible with a traditional watch.</li><br>
                        <br/>
                             <li><strong>Better health analysis and suggestions</strong> - <em>MacRumors</em> reader <a href="https://forums.macrumors.com/threads/what-do-you-want-in-watchos-5.2119197/#post-26069924">Bluecoast</a> would like to see Apple better take advantage of the health information it collects with the watch to add recommendations and coaching for those who are aiming to meet health goals, as well as deeper analysis.</li>
                        <br/>
                        </ul>
                        <br/>
                        Is there something you're hoping to see in watchOS 5 that didn't make it on our list? Make sure to let us know in the comments.<br/><br/><div class="linkback">Related Roundups: <a href="https://www.macrumors.com/roundup/apple-watch/">Apple Watch</a>, <a href="https://www.macrumors.com/roundup/watchos-4/">watchOS 4</a></div><div class="linkback">Buyer's Guide: <a href="https://buyersguide.macrumors.com/#Apple_Watch">Apple Watch (Neutral)</a></div><br/><a href="https://forums.macrumors.com/threads/watchos-5-macrumors-readers-wishlist.2120199/">Discuss this article</a> in our forums<br/><br/><div class="feedflare">
                        <a href="http://feeds.macrumors.com/~ff/MacRumors-All?a=RX63eHcExOg:hdMVyQyuq84:6W8y8wAjSf4"><img src="http://feeds.feedburner.com/~ff/MacRumors-All?d=6W8y8wAjSf4" border="0"></img></a> <a href="http://feeds.macrumors.com/~ff/MacRumors-All?a=RX63eHcExOg:hdMVyQyuq84:qj6IDK7rITs"><img src="http://feeds.feedburner.com/~ff/MacRumors-All?d=qj6IDK7rITs" border="0"></img></a>
                        </div><img src="http://feeds.feedburner.com/~r/MacRumors-All/~4/RX63eHcExOg" height="1" width="1" alt=""/>
                        """
            
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
    
    
    //MARK: - Attachment views
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let imageAttachment = attachment as? DTImageTextAttachment {
            print("found an image")
            // if the attachment has a hyperlinkURL then this is currently ignored
            if imageAttachment.originalSize != CGSize.zero {
                let imageView = DTLazyImageView(frame: frame)
                imageView.delegate = self
                
                // sets the image if there is one
                imageView.image = imageAttachment.image
                
                // url for deferred loading
                imageView.url = imageAttachment.contentURL
                print("imageview first frame width: \(imageView.frame.width)")
                return imageView
            }
        } else if let iframeAttachment = attachment as? DTIframeTextAttachment {
            print("found an iframe")
            let aspectRatio = iframeAttachment.originalSize.width / iframeAttachment.originalSize.height
            iframeAttachment.displaySize = CGSize(width: bodyContent.frame.width, height: bodyContent.frame.width / aspectRatio)
            let videoView = DTWebVideoView(frame: frame)
            videoView.attachment = iframeAttachment
            return videoView;
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
            if oneAttachment.originalSize == CGSize.zero {
                print("equal to zero")
                oneAttachment.originalSize = CGSize(width: bodyContent.frame.width, height: 10) //imageSize
                didUpdate = true
            } else {
                print("not equal to zero")
                //(oneAttachment as! DTTextAttachment).originalSize = size
                let aspectRatio = size.width / size.height
                oneAttachment.displaySize = CGSize(width: bodyContent.frame.width, height: bodyContent.frame.width / aspectRatio) //imageSize
                didUpdate = true
            }
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
    
    override func viewDidLayoutSubviews() {
        print("view did layout subviews")
        
        //bodyContent.layouter = nil
        //bodyContent.relayoutText()
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
