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
            //print(html)
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
            
//            let data = html.data(using: .utf8)
//            let attrString = NSAttributedString(htmlData: data, options:[DTUseiOS6Attributes: true, DTMaxImageSize: CGSize(width: 40, height: 40)], documentAttributes:nil)
//            var muteAttString = NSMutableAttributedString(attributedString: attrString!)
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
            
            
            
            
            

            var string = """
                        <div class="content">Apple plans to introduce the next-generation version of iOS, iOS 12, on June 4 at its Worldwide Developers Conference. Rumors have suggested this is going to be a bug fix and performance improvement update, with Apple delaying some features until iOS 13 to focus on these internal changes.
                        <br>

                        <br>
                        There are, however, rumors that we may see updates that include cross-platform apps for Mac and iOS devices, new Animoji, Animoji support for FaceTime, updated parental controls, and an enhanced version of Do Not Disturb. Rumors never cover all of the features that we see in new versions of iOS, though, so there could be additional changes in the works.
                        <br>

                        <br>
                        <img src="//cdn.macrumors.com/article-new/2018/01/ios12-800x438.jpg" alt="" width="800" height="438" class="aligncenter size-large wp-image-618020">
                        <br>
                        With that in mind, we've taken a look at some of the most-desired features <em>MacRumors</em> readers are hoping for in iOS 12, <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430">pulled from our forums</a>.
                        <br>

                        <br>
                        <h2>User Interface Changes</h2>
                        <br>
                        <ul>
                        <li><strong>Dark mode</strong> - Unsurprisingly, a system wide dark mode for iOS is one of the <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25822552">most hoped for</a> features for iOS 12, just as it was for iOS 11 and iOS 10. Apple users have wanted a true dark mode for years, but there's no word that it's coming in iOS 12. <br><br><img src="//cdn.macrumors.com/article-new/2016/06/darkmodeconceptmail-800x554.jpg" alt="" width="800" height="554" class="aligncenter size-large wp-image-505573"><em><center>A dark mode concept from <a href="//www.macrumors.com/2016/06/06/ios-10-concept-dark-mode/">iHelpBR</a></center></em></li><br>
                        <li><strong>Split Screen mode for iPhone</strong> - The option to <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-3#post-25870446">run two apps</a> side by side on the iPhone would be useful on larger iPhones, especially with rumors pointing towards a 6.5-inch iPhone in 2018.</li><br>
                        <li><strong>More customization</strong> - <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/what-do-you-want-to-see-in-ios-12.2119194/#post-26066444">Breezygirl</a> would like to see Apple add more Android-like customization options, such as the ability to change the background in messages, adjust the SMS bubble colors, or add a theme to the OS to shift the colors.</li><br>
                        <li><strong>Desktop mode</strong> - On some Android devices, there's a feature where you can dock a smartphone to use it as a desktop machine replacement, attaching it to a larger display, a keyboard, and a mouse. It's a long shot, but <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-4#post-26052775">Marrakas</a> would like to see Apple implement similar functionality.</li><br>
                        <li><strong>Volume redesign</strong> - The design of the indicator when you adjust the volume on the iPhone has always been a point of contention with iOS users, and so it's no surprise that in iOS 12, <em>MacRumors</em> readers are hoping for a new, less intrusive volume interface that takes up less screen space. <br><br><img src="//cdn.macrumors.com/article-new/2018/05/iphonevolumecontrol.jpg" alt="" width="600" height="335" class="aligncenter size-full wp-image-637543"></li><br>
                        <li><strong>Improved battery widget</strong> - The battery widget <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-2#post-25860299">could be improved</a> by allowing all of a user's devices to be displayed for quick cross-device battery checks.</li><br>
                        <li><strong>No more shake to undo</strong> - Several <em>MacRumors</em> readers <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-4#post-26055789">are tired</a> of the shake to undo/redo feature in the iPhone, which can be activated accidentally. Some readers would like to see an undo feature enabled through a different gesture.</li>
                        </ul>

                        <br>
                        <h2>App Improvements</h2>
                        <br>
                        <ul>
                        <li><strong>Camera controls in the Camera app</strong> - On a lot of Android devices, the camera app provides manual controls for photo taking. Apple has no similar feature for full manual control, and it would be nice if it were an option, even one that had to be toggled on in Settings. Other settings are hidden in the Settings app, and users would like to see these more readily accessible.</li><br>
                        <li><strong>Aspect Ratio in Camera app</strong> - Multiple <em>MacRumors</em> <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-5#post-26066726">readers</a> would like to see an option to set a default aspect ratio for photos.</li><br>
                        <li><strong>FaceTime</strong> - Several <em>MacRumors</em> readers are hoping for group FaceTime. Rumors suggest Apple's working on it, but it might not come in iOS 12. Animoji are expected to come to FaceTime, though, so you can converse with friends and family as an Animoji character. <br><br><img src="//cdn.macrumors.com/article-new/2017/01/facetime-800x462.jpg" alt="" width="800" height="462" class="aligncenter size-large wp-image-544646"></li><br>
                        <li><strong>App Store wishlists</strong> - The revamped App Store in iOS 11 removed app wishlists that some users took advantage of often. This is a feature that quite a few people miss.</li><br>
                        <li><strong>Photos improvements</strong> - <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25822287">kirky29</a> is hoping for a major overhaul to the Photos app with a lot more functionality for doing things like viewing and editing metadata, changing grid size, altering the order of the photos, and more.</li><br>
                        <li><strong>Music app overhaul</strong> - <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/what-do-you-want-to-see-in-ios-12.2119194/#post-26066556">GermanSuplex</a> has several suggestions for ways Apple could improve the Music app, including the ability to turn iCloud purchases off if desired, improved playcount syncing across devices, the ability to sort songs within playlists by different parameters, refinements and improvements to cloud services and the way the app handles metadata, more control over which devices playlists sync to, and better syncing of music content in general.</li><br>
                        <li><strong>Messages search and archive</strong> - A more robust search feature for the Messages app would be a welcome change, as would an option to archive messages and snooze messages, as Joseph H <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-5#post-26066726">points out</a>.</li>
                        </ul>

                        <br>
                        <h2>iPad</h2>
                        <br>
                        <ul>
                        <li><strong>Mouse support on iPad</strong> - This one is a long shot, but <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25823203">boston04and07</a> wants to see Apple add mouse support for the iPad for navigating through apps.</li><br>
                        <li><strong>iPhone apps for iPad</strong> - Multiple iPhone apps, including Weather, Calculator, Health, and Activity are missing from the iPad and have been exclusive to the iPhone for years.</li>
                        </ul>

                        <br>
                        <h2>Settings and Systemwide Features</h2>
                        <br>
                        <ul>
                        <li><strong>Revamped Wi-Fi and Bluetooth Toggles</strong> - With iOS 11, Apple changed the functionality of the Wi-Fi and Bluetooth toggles in the Control Center. These buttons no longer permanently turn off Wi-Fi and Bluetooth, and instead just disable the features for a set amount of time. In iOS 12, <em>MacRumors</em> readers would like to see the on/off functionality returned or enabled through <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25823646">another gesture</a>, such as a longer press. <br><br><img src="//cdn.macrumors.com/article-new/2017/11/controlcenterwifitoggles-800x707.jpg" alt="" width="800" height="707" class="aligncenter size-large wp-image-603630"></li><br>
                        <li><strong>Do Not Disturb improvements</strong> - Do Not Disturb functionality on the iPhone is fairly basic, and that is actually one of the features Apple's rumored to be working on for iOS 12. The ability to toggle DND on and off for specific apps would be useful, as <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25823203">boston04and07</a> points out, and being able to set schedules for different days of the week would <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-2#post-25829185">also be useful</a>. An option to <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-5#post-26066726">hide notifications entirely</a> would be a welcome change for those who want to use their devices in peace. </li><br>
                        <li><strong>Biometric locking for specific apps</strong> - Third-party apps can require you to use a fingerprint, Face ID, or a password to access sensitive data, but as <em>MacRumors</em> reader <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/#post-25824591">TimFL1</a> says, this isn't available for first-party apps like Photos, nor for specific parts of apps, like individual photo albums.</li><br>
                        <li><strong>iCloud notifications</strong> - If you have multiple devices and get a notification from an app like Apple News, it goes to all of your devices instead of just one, and viewing the notification on just one device doesn't clear it from all of them. If Apple <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-2#post-25827281">implemented iCloud notifications</a>, notifications would work more smoothly across devices, appearing on just one device and clearing on all.</li>
                        </ul>

                        <br>
                        <h2>iPhone X</h2>
                        <br>
                        <ul>
                        <li><strong>Always-on display for iPhone X</strong> - Some Android smartphones offer an always-on display, something that Apple could perhaps theoretically enable thanks to the OLED display on the iPhone X, which eats up less battery life. <em>MacRumors</em> readers would like to see <a href="//forums.macrumors.com/threads/ios-12-wishlist.2106430/page-3#post-25906684">an always-on display</a> on the iPhone X for things like the time and incoming notifications, even though it's probably a long shot at this point in time.</li>
                        </ul>

                        <br>
                        <h2>AI</h2>
                        <br>
                        <ul>
                        <li><strong>Siri</strong> - Improvements to Siri was one of the most frequent requests, with specifics that include Spotify integration, multi-lingual query support, and, in general, just features to make Siri smarter and more like Alexa or Google Assistant.</li>
                        </ul>
                        More than anything, most of our readers are hoping that Apple is going to hunker down and focus on bug fixes and performance improvements to make existing features operate smoothly and without issues.
                        <br>

                        <br>
                        Apple is said to be planning to address stability and performance concerns in this update, and has gone as far as delaying planned features in favor of underlying fixes.
                        <br>

                        <br>
                        Do you have other features you're hoping to see in iOS 12 that didn't make our list? Let us know in the comments.<br><br><div class="linkback">Related Roundup: <a href="//www.macrumors.com/roundup/ios-12/">iOS 12</a></div></div>
                        """

            var newRanges = ["fewswfe".ranges(of: "ew").first]
            newRanges.remove(at: 0)
            
            var j = [Int]()
            
            let imgs = string.ranges(of: "<img(.*?)>", options: .regularExpression).map{string[$0]}
            var imgRange = "fewswfe".ranges(of: "ew").first
            var newRange = "fewswfe".ranges(of: "ew").first
            for (i, img) in imgs.reversed().enumerated() {
                //imgArray.append(String(img))
                //let iframeView = IframeWebView(frame: CGRect(x: 20, y: 20, width: 100, height: 70))
                //iframeView.loadIframeString(iframe: String(iframe))
                //let subviewTextAttachment = SubviewTextAttachment(view: iframeView)
                //let attributedString = NSAttributedString(attachment: subviewTextAttachment)
                imgRange = img.startIndex..<img.endIndex
                //mutableAttributedString.replaceCharacters(in: NSRange(imgRange, in: string), with: attributedString)
                string.replaceSubrange(imgRange!, with: "zxcv"+String(i))
                newRange = string.range(of: "zxcv"+String(i))
                
                newRanges.append(newRange)
                j.append(i)
            }
            
            let data = string.data(using: .utf8)
            let attrString = NSAttributedString(htmlData: data, options:[DTUseiOS6Attributes: true, DTMaxImageSize: CGSize(width: 40, height: 40)], documentAttributes:nil)
            var muteAttString = NSMutableAttributedString(attributedString: attrString!)
            //var imgArray = [String]()
            
            for (i, jz) in j.enumerated() {
                let textAttachment = NSTextAttachment()
                textAttachment.image = UIImage(named: "articleSampleImage.png")
                var attrStringWithImage = NSAttributedString(attachment: textAttachment)
                
                let z = string.range(of: "zxcv"+String(jz))
                muteAttString.replaceCharacters(in: NSRange(z!, in: string), with: attrStringWithImage)
            }
            
            bodyContent.attributedText = muteAttString
            
            //muteAttString.ran
            
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
