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
    @IBOutlet weak var bodyContent: UIView!
    
    var articleSubviews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bodyContent.delegate = self
        //webView.navigationDelegate = self

        //560x315
        //337x190

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let att = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium),
                   NSAttributedStringKey.paragraphStyle: paragraphStyle]
        //attributedString1.addAttributes(att, range: NSRange(location: 0, length: attributedString1.length))
        
        
        
        let test = """
<iframe width="560" height="315" src="https://www.youtube.com/embed/tnmfr0KxDHg" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></center><center><em><a href="https://www.youtube.com/user/macrumors?sub_confirmation=1">Subscribe to the MacRumors YouTube channel</a> for more videos.</em></center>
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
        

        let sections = splitArticleIntoSections(html: test)
        addArticleSubviews(sections: sections)
    }


    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        let svc = SFSafariViewController(url: URL)
        self.present(svc, animated: true, completion: nil)
        return false
    }
    

    
    
    func addArticleSubviews(sections: [ArticleSection]) {
        for (i, section) in sections.enumerated() {
            var sectionView = UIView(frame: bodyContent.bounds)
            
            if section.type == .iframe {
                let iframeView = IframeWebView(frame: bodyContent.bounds, configuration: WKWebViewConfiguration())
                iframeView.scrollView.isScrollEnabled = false
                iframeView.loadIframeString(iframe: section.html)
                
                let aspectRatioConstraint = NSLayoutConstraint(item: iframeView, attribute: .height, relatedBy: .equal, toItem: iframeView, attribute: .width, multiplier: 1/iframeView.aspectRatio!, constant: 0)
                iframeView.addConstraint(aspectRatioConstraint)
                
                sectionView = iframeView
            } else {
                let textView = UITextView(frame: bodyContent.bounds)
                textView.isEditable = false
                textView.isScrollEnabled = false
                textView.attributedText = section.html.convertHtml()
                textView.delegate = self
                
                sectionView = textView
            }
            
            sectionView.backgroundColor = UIColor.blue
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            bodyContent.addSubview(sectionView)
            
            let leadingConstraint = NSLayoutConstraint(item: sectionView, attribute: .leading, relatedBy: .equal, toItem: bodyContent, attribute: .leading, multiplier: 1.0, constant: 0)
            bodyContent.addConstraint(leadingConstraint)
            
            let trailingConstraint = NSLayoutConstraint(item: sectionView, attribute: .trailing, relatedBy: .equal, toItem: bodyContent, attribute: .trailing, multiplier: 1.0, constant: 0)
            bodyContent.addConstraint(trailingConstraint)
            
            if(i == 0) {
                let topConstraint = NSLayoutConstraint(item: sectionView, attribute: .top, relatedBy: .equal, toItem: bodyContent, attribute: .top, multiplier: 1.0, constant: 0)
                bodyContent.addConstraint(topConstraint)
            } else {
                let topConstraint = NSLayoutConstraint(item: sectionView, attribute: .top, relatedBy: .equal, toItem: articleSubviews[i-1], attribute: .bottom, multiplier: 1.0, constant: 10)
                bodyContent.addConstraint(topConstraint)
            }
            if(i == sections.count-1) {
                let bottomConstraint = NSLayoutConstraint(item: sectionView, attribute: .bottom, relatedBy: .equal, toItem: bodyContent, attribute: .bottom, multiplier: 1.0, constant: 0)
                bodyContent.addConstraint(bottomConstraint)
            }
        
            articleSubviews.append(sectionView)
        }
    }
    

}

extension String{
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
}




struct ArticleSection {
    var type: ArticleSectionType
    var html: String
    
    enum ArticleSectionType {
        case text
        case iframe
    }
}




func splitArticleIntoSections(html: String) -> [ArticleSection] {
    let iframes = html.ranges(of: "<iframe(.*?)</iframe>", options: .regularExpression).map{html[$0] }
    
    var sections = [ArticleSection]()
    var index = html.startIndex
    for iframe in iframes {
        let range = index..<iframe.startIndex
        let text = String(html[range])
        if !text.isEmpty {
            let textSection = ArticleSection(type: .text, html: text)
            sections.append(textSection)
        }
        
        let iframeSection = ArticleSection(type: .iframe, html: String(iframe))
        sections.append(iframeSection)
        
        index = iframe.endIndex
    }
    let range = index..<html.endIndex
    let text = String(html[range])
    if !text.isEmpty {
        let textSection = ArticleSection(type: .text, html: text)
        sections.append(textSection)
    }
    
    return sections
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
