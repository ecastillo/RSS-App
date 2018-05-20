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
//import ContentFittingWebView
import SwiftSoup
import Foundation

class ArticleViewController: UIViewController, UITextViewDelegate, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var bodyContent: UITextView!
    //@IBOutlet weak var webView: IframeWebView!
    //@IBOutlet weak var bodyContent2: UITextView!
    //@IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodyContentBottomConstraint: NSLayoutConstraint!
    
    var webString: String = ""
    
    var articleSubviews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyContent.delegate = self
        //webView.navigationDelegate = self

        let attributedString1 = "At its <a href=\"https://www.macrumors.com/2018/05/08/google-assistant-improvements-google-io/\">Google I/O developer conference</a> last week, Google debuted a <a href=\"https://www.blog.google/products/news/new-google-news-ai-meets-human-intelligence/\">revamped Google News app</a> focusing on balanced news delivery with personalized news suggestions, and as of today, the new Google News app is available for download on the iPhone and iPad.<br/><br/>According to Google, the News app is designed to use \"the best of artificial intelligence to find \"the best of human intelligence\" by taking advantage of new AI techniques to organize a constant flow of new information into digestible storylines.<br/><br/><!--<img src=\"http://cdn.macrumors.com/article-new/2018/05/googlenewsapp-800x564.jpg\" alt=\"\" width=\"800\" height=\"564\" class=\"aligncenter size-large wp-image-636602\" />--><br/><center>".convertHtml()
        webString = """
                    <iframe src=\"https://www.youtube.com/embed/wArETCVkS4g\" width="560" height="315" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"></iframe>
                    """
        //560x315
        //337x190
        let attributedString2 = "</center><br/>Google News for iOS replaces the existing Google Play Newsstand app, which has been overhauled with a new name and a new design with the launch of Google News. Full release notes for the update are below:<blockquote>Google Play Newsstand is now Google News!<br/>What's new:<br/>- Enjoy an entirely new, cleaner look, designed for a better reading experience<br/>- Get up to speed with a smarter briefing that shows you the top five stories for you right now<br/>- Explore all the coverage of a story in one place. See a timeline of events, FAQs, people and places involved, perspectives, analysis and more for every news story<br/>- Subscribe to credible sources with a single click</blockquote>Google News can be downloaded from the App Store for free. [<a href=\"https://itunes.apple.com/us/app/google-news/id459182288?mt=8\">Direct Link</a>]<br/><br/><div class=\"linkback\">Tag: <a href=\"https://www.macrumors.com/roundup/google/\">Google</a></div><br/><a href=\"https://forums.macrumors.com/threads/google-revamped-news-app-ios-devices.2118935/\">Discuss this article</a> in our forums<br/><br/><div class=\"feedflare\"><a href=\"http://feeds.macrumors.com/~ff/MacRumors-All?a=1OaudMR-xbU:aMwyx0CBM8A:6W8y8wAjSf4\"><img src=\"http://feeds.feedburner.com/~ff/MacRumors-All?d=6W8y8wAjSf4\" border=\"0\"></img></a> <a href=\"http://feeds.macrumors.com/~ff/MacRumors-All?a=1OaudMR-xbU:aMwyx0CBM8A:qj6IDK7rITs\"><img src=\"http://feeds.feedburner.com/~ff/MacRumors-All?d=qj6IDK7rITs\" border=\"0\"></img></a></div><img src=\"http://feeds.feedburner.com/~r/MacRumors-All/~4/1OaudMR-xbU\" height=\"1\" width=\"1\" alt=\"\"/>\"".convertHtml()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let att = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium),
                   NSAttributedStringKey.paragraphStyle: paragraphStyle]
        attributedString1.addAttributes(att, range: NSRange(location: 0, length: attributedString1.length))
        
        
        
        let test = """
Google recently introduced <a href="https://www.macrumors.com/2018/05/15/google-revamped-news-app-ios-devices/">a new Google News app</a> with an entirely updated interface and a range of new features that put it on par with Apple's own News app, including a "For You" recommendation section and "Full Coverage" headlines that present a story from multiple angles.
<br/>

<br/>
We went hands-on with Google News to check out the new features and to see how it compares to Apple News, the built-in news app that's available on the iPhone and the iPad.
<br/>

<br/>
<center><iframe width="560" height="315" src="https://www.youtube.com/embed/tnmfr0KxDHg" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></center><center><em><a href="https://www.youtube.com/user/macrumors?sub_confirmation=1">Subscribe to the MacRumors YouTube channel</a> for more videos.</em></center>
<br/>
The Google News app is a reimagining and revamp to the existing Google Newsstand Play app that was previously available via the iOS App Store. It's been entirely overhauled though, with a simple, clean interface that's fairly similar to the look of Apple News with a dedicated navigation bar at the bottom.
<br/>

<br/>
Google News does, however, have an additional section for quickly selecting news categories like U.S., World, Business, and Technology.
<br/>
<iframe width="560" height="315" src="https://www.youtube.com/embed/tnmfr0KxDHg" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
<br/>
Both apps feature a "For You" section based on personalized recommendations. Apple's draws in information from the categories and news sites you choose to follow, while Google presents a selection of stories that become more tailored over time based on what you choose to read and what you favorite.
<br/>

<br/>
In each app, you can search for different news sites, blogs, and topics and add them to your coverage lists to impact "For You." Google's For You section highlights a list of five top stories and then provides supplemental stories at the bottom of the list, while Apple organizes For You into top stories, trending stories, top videos, and then recommendations based on channels and topics.
<br/>

<br/>
Apple News features a "Spotlight" section that features curated news selected by Apple News Editors, which highlights interesting news topics that you might not have otherwise seen.
<br/>

<br/>
Google News doesn't have a similar feature, but it has its own unique offering in the form of the "Headlines" section that aggregates the top news stories at the current time. In the headlines section, major stories have a "Full Coverage" option that lets you see the same story from multiple news sites so all of the angles are covered.
<br/>

<br/>
Google also has a dedicated "Newsstand" tab that lets you subscribe to paid and free news sources and a range of magazines using payment information stored in your Google Play account. Apple doesn't have a similar feature right now, but such an option is said to be in the works following its <a href="https://www.macrumors.com/2018/03/12/apple-acquires-texture/">acquisition</a> of magazine subscription service Texture.
<br/>

<br/>
Have you checked out Google News? Do you prefer it over Apple's own news app? Let us know in the comments.<br/><br/><div class="linkback">Tags: <a href="https://www.macrumors.com/roundup/google/">Google</a>, <a href="https://www.macrumors.com/roundup/apple-news/">Apple News</a></div><br/><a href="https://forums.macrumors.com/threads/google-news-vs-apple-news.2119311/">Discuss this article</a> in our forums<br/><br/><div class="feedflare">
<a href="http://feeds.macrumors.com/~ff/MacRumors-All?a=yftAeWQRmT4:JDxgeTz4zoA:6W8y8wAjSf4"><img src="http://feeds.feedburner.com/~ff/MacRumors-All?d=6W8y8wAjSf4" border="0"></img></a> <a href="http://feeds.macrumors.com/~ff/MacRumors-All?a=yftAeWQRmT4:JDxgeTz4zoA:qj6IDK7rITs"><img src="http://feeds.feedburner.com/~ff/MacRumors-All?d=qj6IDK7rITs" border="0"></img></a>
</div><img src="http://feeds.feedburner.com/~r/MacRumors-All/~4/yftAeWQRmT4" height="1" width="1" alt=""/><iframe width="560" height="315" src="https://www.youtube.com/embed/tnmfr0KxDHg" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
"""
        splitArticleHTML(html: test)
        
        
        
//        attributedString.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, attributedString.length), options: .init(rawValue: 0), using: { (value, range, stop) in
//            if let attachement = value as? NSTextAttachment {
//                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
//                let contentSize: CGRect = self.bodyContent.bounds
//                print("image width: \(image.size.width)")
//                print("content width: \(contentSize.width)")
//                if image.size.width > contentSize.width {
//                    let newImage = image.resizeImage(scale: contentSize.width/image.size.width)
//                    let newAttribut = NSTextAttachment()
//                    newAttribut.image = newImage
//                    attributedString.addAttribute(NSAttributedStringKey.attachment, value: newAttribut, range: range)
//                }
//            }
//        })
        
        
        
        bodyContent.attributedText = attributedString1
        //webView.loadHTMLString(webString, baseURL: nil)
        //bodyContent2.attributedText = attributedString2
        
//        let webView = IframeWebView(frame: scrollContent.bounds, configuration: WKWebViewConfiguration())
//        webView.backgroundColor = UIColor.blue
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        scrollContent.addSubview(webView)
//
//        webView.loadIframeString(iframe: webString)
//        print("webview frame width: \(webView.frame.width)")
//        print("new iframe height: \(webView.bounds.width / webView.aspectRatio!)")
//        //bodyContent.removeConstraint(bodyContentBottomConstraint)
//        scrollContent.addConstraint(NSLayoutConstraint(item: webView,
//                                                 attribute: .top,
//                                                 relatedBy: .equal,
//                                                 toItem: bodyContent,
//                                                 attribute: .bottom,
//                                                 multiplier: 1.0,
//                                                 constant: 10))
//        scrollContent.addConstraint(NSLayoutConstraint(item: webView,
//                                                 attribute: .leading,
//                                                 relatedBy: .equal,
//                                                 toItem: scrollContent,
//                                                 attribute: .leading,
//                                                 multiplier: 1.0,
//                                                 constant: 19))
//        scrollContent.addConstraint(NSLayoutConstraint(item: scrollContent,
//                                                 attribute: .trailing,
//                                                 relatedBy: .equal,
//                                                 toItem: webView,
//                                                 attribute: .trailing,
//                                                 multiplier: 1.0,
//                                                 constant: 19))
//        scrollContent.addConstraint(NSLayoutConstraint(item: webView,
//                                                       attribute: .bottom,
//                                                       relatedBy: .equal,
//                                                       toItem: scrollContent,
//                                                       attribute: .bottom,
//                                                       multiplier: 1.0,
//                                                       constant: 0))
//        webView.addConstraint(NSLayoutConstraint(item: webView,
//                                                        attribute: .height,
//                                                        relatedBy: .equal,
//                                                        toItem: webView,
//                                                        attribute: .width,
//                                                        multiplier: 1/webView.aspectRatio!,
//                                                        constant: 0))
//
        
        let pieces = splitArticleHTML(html: test)
        addArticleSubviews(pieces: pieces)
    }


    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        let svc = SFSafariViewController(url: URL)
        self.present(svc, animated: true, completion: nil)
        return false
    }
    

    
    
    func addArticleSubviews(pieces: [What]) {
        var i = 0
        for piece in pieces {
            if piece.type == "iframe" {
                print("i: \(i)")
                let webView = IframeWebView(frame: scrollContent.bounds, configuration: WKWebViewConfiguration())
                webView.backgroundColor = UIColor.blue
                webView.translatesAutoresizingMaskIntoConstraints = false
                scrollContent.addSubview(webView)
                
                webView.loadIframeString(iframe: piece.html)
                
                scrollContent.addConstraint(NSLayoutConstraint(item: webView,
                                                               attribute: .leading,
                                                               relatedBy: .equal,
                                                               toItem: scrollContent,
                                                               attribute: .leading,
                                                               multiplier: 1.0,
                                                               constant: 19))
                scrollContent.addConstraint(NSLayoutConstraint(item: scrollContent,
                                                               attribute: .trailing,
                                                               relatedBy: .equal,
                                                               toItem: webView,
                                                               attribute: .trailing,
                                                               multiplier: 1.0,
                                                               constant: 19))
                webView.addConstraint(NSLayoutConstraint(item: webView,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: webView,
                                                         attribute: .width,
                                                         multiplier: 1/webView.aspectRatio!,
                                                         constant: 0))
                
                if(i == 0) {
                    scrollContent.addConstraint(NSLayoutConstraint(item: webView,
                                                                   attribute: .top,
                                                                   relatedBy: .equal,
                                                                   toItem: bodyContent,
                                                                   attribute: .bottom,
                                                                   multiplier: 1.0,
                                                                   constant: 10))
                } else {
                    scrollContent.addConstraint(NSLayoutConstraint(item: webView,
                                                                   attribute: .top,
                                                                   relatedBy: .equal,
                                                                   toItem: articleSubviews[i-1],
                                                                   attribute: .bottom,
                                                                   multiplier: 1.0,
                                                                   constant: 10))
                }
                if(i == 2) {
                    scrollContent.addConstraint(NSLayoutConstraint(item: webView,
                                                                   attribute: .bottom,
                                                                   relatedBy: .equal,
                                                                   toItem: scrollContent,
                                                                   attribute: .bottom,
                                                                   multiplier: 1.0,
                                                                   constant: 0))
                }
                
                articleSubviews.append(webView)
                i = i+1
            }
            
        }
    }
    

}

extension String{
    func convertHtml() -> NSMutableAttributedString{
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            //return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch{
            return NSMutableAttributedString()
        }
    }
}

extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage {
        //print("bodyContent frame width: \(self.bodyContent.frame.width)")
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        print("new image width: \(self.size.width*scale)")
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


class What {
    var type = ""
    var html = ""
}


func splitArticleHTML(html: String) -> [What] {
    let iframes = html.ranges(of: "<iframe(.*?)</iframe>", options: .regularExpression).map{html[$0] }
    
    var pieces = [What]()
    var index = html.startIndex
    for iframe in iframes {
        let what = What()
        what.type = "non-iframe"
        let range = index..<iframe.startIndex
        what.html = String(html[range])
        pieces.append(what)
        
        let what2 = What()
        what2.type = "iframe"
        what2.html = String(iframe)
        pieces.append(what2)
        
        index = iframe.endIndex
    }
    let range = index..<html.endIndex
    let what = What()
    what.type = "non-iframe"
    what.html = String(html[range])
    pieces.append(what)
    
    return pieces
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
