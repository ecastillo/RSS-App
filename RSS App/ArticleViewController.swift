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
import FeedKit
import DateToolsSwift
import SubviewAttachingTextView
import Atributika
import DTCoreText

class ArticleViewController: UIViewController, UITextViewDelegate, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bodyContent: SubviewAttachingTextView!
    
    
    var articleSubviews = [UIView]()
    
    var article: RSSFeedItem?
    
    var articleContent = """
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTitle.text = article?.title
        
        if let link = article?.link {
            let url = URL(string: link)
            let domain = url?.host?.replacingOccurrences(of: "^www\\.*", with: "", options: .regularExpression)
            website.setTitle(domain, for: .normal)
        }
        
        date.text = article?.pubDate?.timeAgoSinceNow
        
        do {
            let doc: Document = try SwiftSoup.parse(article!.description!)
            let img: Element = try! doc.select("img").first()!
            let imgSrc: String = try! img.attr("src")
            let data = try Data(contentsOf: URL(string: imgSrc)!)
            let imgz = UIImage(data: data)
            if(Int((imgz?.size.width)!) > 200) {
                featuredImage.sd_setImage(with: URL(string: imgSrc), placeholderImage: nil)
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }

        //560x315
        //337x190
        
        //let sections = splitArticleIntoSections(html: (article?.description!)!)
        //addArticleSubviews(sections: sections)
        
        test()
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
                
                textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
                textView.textContainer.lineFragmentPadding = 0.0
                
                let attributedString = section.html.convertHtml()
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                let att = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium),
                           NSAttributedStringKey.paragraphStyle: paragraphStyle]
                attributedString.addAttributes(att, range: NSRange(location: 0, length: attributedString.length))
                
                attributedString.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, attributedString.length), options: .init(rawValue: 0), using: { (value, range, stop) in
                    if let attachement = value as? NSTextAttachment {
                        let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                        let contentSize: CGRect = textView.bounds
                        if image.size.width > contentSize.width {
                            let newImage = image.resizeImage(scale: contentSize.width/image.size.width)
                            let newAttribute = NSTextAttachment()
                            newAttribute.image = newImage
                            attributedString.addAttribute(NSAttributedStringKey.attachment, value: newAttribute, range: range)
                        }
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                        let att = [NSAttributedStringKey.paragraphStyle: paragraphStyle]
                        attributedString.addAttributes(att, range: range)
                        
                        let lineBreak = NSAttributedString(string: "\n")
                        attributedString.insert(lineBreak, at: range.upperBound)
                    }
                })
                
                textView.attributedText = attributedString
                textView.delegate = self
                
                sectionView = textView
            }
            
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
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        let url = URL(string: (article?.link)!)
        let svc = SFSafariViewController(url: url!)
        self.present(svc, animated: true, completion: nil)
    }
    
    func test() {
        if var html = article?.description {
            print(html)
            html = """
                    That video is "<a href="https://www.youtube.com/watch?v=FdS3tjEIqUA">I Am Pressing The Spacebar and Nothing Is Happening</a>," uploaded to YouTube by <a href="https://www.youtube.com/watch?v=4pH-bEzMCZM">song-a-day</a> musician Jonathan Mann.
                    <br/>

                    <br/>
                    <center><iframe width="560" height="315" src="https://www.youtube.com/embed/FdS3tjEIqUA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></center>
                    <br/>
                    The complaint adds that Apple is "aware of" or "should have known" about the defect through either pre-release product testing, customer complaints, or a combination of the two, but has "at all times failed to disclose that the keyboard is defective" because repairs and replacements prove to be costly.<blockquote>Apple knew or should have known of the butterfly keyboard defects before the Laptops were ever sold to the public, as a result of standard pre-release product testing. Further… Apple knew or should have known that that the Laptops were defective shortly after the 12-inch MacBooks were initially launched in 2015, and shortly after the MacBook Pros were launched in 2016, because, shortly after each launch, the keyboard was the subject of numerous consumer complaints published on the Company's website and a variety of internet message boards, such as MacRumors, social and traditional media, and retailer websites. Apple continuously monitors its own website as well as other web pages, including MacRumors…</blockquote>This complaint, like the first, acknowledges that Apple provides a <a href="https://support.apple.com/en-us/HT205662">support document</a> with instructions to clean the keyboard of a MacBook or MacBook Pro with "an unresponsive key or "a key that feels different than the other keys," but notes that the steps "will not permanently repair the defect."
                    """
            //let attributedString = html.convertHtml()
            //let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            let data = html.data(using: .utf8)
            let attrString = NSAttributedString(htmlData: data, options:[DTUseiOS6Attributes: true, DTMaxImageSize: CGSize(width: 40, height: 40)], documentAttributes:nil)
            var muteAttString = NSMutableAttributedString(attributedString: attrString!)
            //print(attrString)
            //self.leadStory.attributedText = attrString!
        
//            let iframes = html.ranges(of: "<iframe(.*?)</iframe>", options: .regularExpression).map{html[$0]}
//        
//            for iframe in iframes.reversed() {
//                let iframeView = IframeWebView(frame: CGRect(x: 20, y: 20, width: 100, height: 70))
//                iframeView.loadIframeString(iframe: String(iframe))
//                let subviewTextAttachment = SubviewTextAttachment(view: iframeView)
//                let attributedString = NSAttributedString(attachment: subviewTextAttachment)
//                let iframeRange = iframe.startIndex..<iframe.endIndex
//                mutableAttributedString.replaceCharacters(in: NSRange(iframeRange, in: html), with: attributedString)
//            }

            //var test = DTHTMLAttributedStringBuilder(html: data, options: [DTUseiOS6Attributes: true, DTMaxImageSize: CGSize(width: 40, height: 40)], documentAttributes: nil).generatedAttributedString()
            //var test2 = NSMutableAttributedString(attributedString: test!)
//            bodyContent.attributedText = test
//            print(test)
            
            //bodyContent.attributedString = attrString
//            bodyContent.translatesAutoresizingMaskIntoConstraints = true
//            bodyContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: "articleSampleImage.png")
            var attrStringWithImage = NSAttributedString(attachment: textAttachment)
            muteAttString.replaceCharacters(in: NSMakeRange(4, 1), with: attrStringWithImage)
            
            bodyContent.attributedText = muteAttString
            
//
//            var string = "hello"
//            var imgArray = [String]()
//
//            let imgs = string.ranges(of: "<img(.*?)>", options: .regularExpression).map{string[$0]}
//            for img in imgs.reversed() {
//                imgArray.append(String(img))
//                //let iframeView = IframeWebView(frame: CGRect(x: 20, y: 20, width: 100, height: 70))
//                //iframeView.loadIframeString(iframe: String(iframe))
//                //let subviewTextAttachment = SubviewTextAttachment(view: iframeView)
//                //let attributedString = NSAttributedString(attachment: subviewTextAttachment)
//                let imgRange = img.startIndex..<img.endIndex
//                //mutableAttributedString.replaceCharacters(in: NSRange(imgRange, in: string), with: attributedString)
//                string.replaceSubrange(imgRange, with: "zxcv1")
//
//
//            }
            
            
            
            
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        bodyContent.frame = CGRect(x: bodyContent.frame.origin.x, y: bodyContent.frame.origin.y, width: bodyContent.frame.width, height: bodyContent.attributedTextContentView.frame.height)
//        bodyContent.backgroundColor = UIColor.red
//        bodyContent.attributedTextContentView.backgroundColor = UIColor.blue
//    }
    
}



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
