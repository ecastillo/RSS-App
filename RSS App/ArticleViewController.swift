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

class ArticleViewController: UIViewController, UITextViewDelegate, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var bodyContent: UITextView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bodyContent2: UITextView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var webString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyContent.delegate = self
        webView.navigationDelegate = self

        let attributedString1 = "At its <a href=\"https://www.macrumors.com/2018/05/08/google-assistant-improvements-google-io/\">Google I/O developer conference</a> last week, Google debuted a <a href=\"https://www.blog.google/products/news/new-google-news-ai-meets-human-intelligence/\">revamped Google News app</a> focusing on balanced news delivery with personalized news suggestions, and as of today, the new Google News app is available for download on the iPhone and iPad.<br/><br/>According to Google, the News app is designed to use \"the best of artificial intelligence to find \"the best of human intelligence\" by taking advantage of new AI techniques to organize a constant flow of new information into digestible storylines.<br/><br/><img src=\"http://cdn.macrumors.com/article-new/2018/05/googlenewsapp-800x564.jpg\" alt=\"\" width=\"800\" height=\"564\" class=\"aligncenter size-large wp-image-636602\" /><br/><center>".convertHtml()
        webString = """
<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body style=\"margin:0\"><iframe src=\"https://www.youtube.com/embed/wArETCVkS4g\" width="560" height="315" frameborder=\"0\" allowfullscreen=\"allowfullscreen\" style=\"background:green\"></iframe>
 <script>
        function resizeIframe() {
            var iframeWidth = document.getElementsByTagName('iframe')[0].getAttribute('width');
            var iframeHeight = document.getElementsByTagName('iframe')[0].getAttribute('height');
            
            var scale = window.innerWidth/iframeWidth;
            
            var newIframeWidth = iframeWidth*scale;
            var newIframeHeight = iframeHeight*scale;
            
            document.getElementsByTagName('iframe')[0].width = newIframeWidth;
            document.getElementsByTagName('iframe')[0].height = newIframeHeight;
        }
        
        resizeIframe();
        
        window.addEventListener('resize', function() {
            resizeIframe();
        });
    </script>
</body></html>
"""
        //560x315
        //337x190
        let attributedString2 = "</center><br/>Google News for iOS replaces the existing Google Play Newsstand app, which has been overhauled with a new name and a new design with the launch of Google News. Full release notes for the update are below:<blockquote>Google Play Newsstand is now Google News!<br/>What's new:<br/>- Enjoy an entirely new, cleaner look, designed for a better reading experience<br/>- Get up to speed with a smarter briefing that shows you the top five stories for you right now<br/>- Explore all the coverage of a story in one place. See a timeline of events, FAQs, people and places involved, perspectives, analysis and more for every news story<br/>- Subscribe to credible sources with a single click</blockquote>Google News can be downloaded from the App Store for free. [<a href=\"https://itunes.apple.com/us/app/google-news/id459182288?mt=8\">Direct Link</a>]<br/><br/><div class=\"linkback\">Tag: <a href=\"https://www.macrumors.com/roundup/google/\">Google</a></div><br/><a href=\"https://forums.macrumors.com/threads/google-revamped-news-app-ios-devices.2118935/\">Discuss this article</a> in our forums<br/><br/><div class=\"feedflare\"><a href=\"http://feeds.macrumors.com/~ff/MacRumors-All?a=1OaudMR-xbU:aMwyx0CBM8A:6W8y8wAjSf4\"><img src=\"http://feeds.feedburner.com/~ff/MacRumors-All?d=6W8y8wAjSf4\" border=\"0\"></img></a> <a href=\"http://feeds.macrumors.com/~ff/MacRumors-All?a=1OaudMR-xbU:aMwyx0CBM8A:qj6IDK7rITs\"><img src=\"http://feeds.feedburner.com/~ff/MacRumors-All?d=qj6IDK7rITs\" border=\"0\"></img></a></div><img src=\"http://feeds.feedburner.com/~r/MacRumors-All/~4/1OaudMR-xbU\" height=\"1\" width=\"1\" alt=\"\"/>\"".convertHtml()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let att = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium),
                   NSAttributedStringKey.paragraphStyle: paragraphStyle]
        attributedString1.addAttributes(att, range: NSRange(location: 0, length: attributedString1.length))
        
        
        
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
        bodyContent2.attributedText = attributedString2
        
        //webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        do {
            let html = webString
            let doc: Document = try SwiftSoup.parse(html)
            let iframe: Element = try! doc.select("iframe").first()!
            let iframeWidth: String = try! iframe.attr("width")
            let iframeHeight: String = try! iframe.attr("height")
            
            print(iframeWidth)
            //webViewHeightConstraint.constant = 2000
            
            if let iframeWidthNum = NumberFormatter().number(from: iframeWidth), let iframeHeightNum = NumberFormatter().number(from: iframeHeight){
                let iframeScale = webView.bounds.width / CGFloat(truncating: iframeWidthNum)
                let newIframeWidth = webView.frame.size.width
                print("webView frame width: \(webView.frame.size.width)")
                let newIframeHeight = CGFloat(truncating: iframeHeightNum) * iframeScale
                
                do {
                    try doc.select("iframe").attr("width", "\(round(newIframeWidth))")
                    try doc.select("iframe").attr("height", "\(ceil(newIframeHeight))")
                    try print(doc.html())
                    try webView.loadHTMLString(doc.html(), baseURL: nil)
                    webViewHeightConstraint.constant = ceil(newIframeHeight)
                    print(webView.frame.size.height)
                    webView.addConstraint(NSLayoutConstraint(item: webView,
                                                                    attribute: NSLayoutAttribute.height,
                                                                    relatedBy: NSLayoutRelation.equal,
                                                                    toItem: webView,
                                                                    attribute: NSLayoutAttribute.width,
                                                                    multiplier: newIframeHeight / newIframeWidth,
                                                                    constant: 0))
                    self.webView.evaluateJavaScript("window.dispatchEvent(new Event('resize'))") { (result, error) in
                        if error != nil {
                            print(result)
                        }
                    }
                    
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
            
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            
            self.webView.evaluateJavaScript("window.dispatchEvent(new Event('resize'))") { (result, error) in
                if error != nil {
                    print(result)
                }
            }
            
            
            
//            do {
//                let html = self.webString
//                let doc: Document = try SwiftSoup.parse(html)
//                let iframe: Element = try! doc.select("iframe").first()!
//                let iframeWidth: String = try! iframe.attr("width")
//                let iframeHeight: String = try! iframe.attr("height")
//
//                print(iframeWidth)
//                //webViewHeightConstraint.constant = 2000
//
//                if let iframeWidthNum = NumberFormatter().number(from: iframeWidth), let iframeHeightNum = NumberFormatter().number(from: iframeHeight){
//                    let iframeScale = self.webView.bounds.width / CGFloat(truncating: iframeWidthNum)
//                    let newIframeWidth = CGFloat(truncating: iframeWidthNum) * iframeScale
//                    let newIframeHeight = CGFloat(truncating: iframeHeightNum) * iframeScale
//
//                    do {
//                        try doc.select("iframe").attr("width", "\(round(newIframeWidth))")
//                        try doc.select("iframe").attr("height", "\(round(newIframeHeight))")
//                        try print(doc.html())
//                        try self.webView.loadHTMLString(doc.html(), baseURL: nil)
//                        self.webViewHeightConstraint.constant = round(newIframeHeight)
//                    } catch Exception.Error(let type, let message) {
//                        print(message)
//                    } catch {
//                        print("error")
//                    }
//                }
//
//            } catch Exception.Error(let type, let message) {
//                print(message)
//            } catch {
//                print("error")
//            }
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        let newFrame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: 200, height: 200)
//        scrollContent.frame = newFrame
//        self.view.layoutIfNeeded()
//    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        let svc = SFSafariViewController(url: URL)
        self.present(svc, animated: true, completion: nil)
        return false
    }
    
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        print("webview finished loading");
//        var newBounds = webView.bounds
//        newBounds.size.height = webView.scrollView.contentSize.height
//        webView.bounds = newBounds
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("webview finished loading");
//        var newBounds = webView.bounds
//        newBounds.size.height = 400 //webView.scrollView.contentSize.height
//        webView.bounds = newBounds
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
