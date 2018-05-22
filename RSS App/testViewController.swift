//
//  testViewController.swift
//  RSS App
//
//  Created by Eric Castillo on 5/19/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SubviewAttachingTextView

class testViewController: UIViewController {

    @IBOutlet weak var textView: SubviewAttachingTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let html = """
                    this is before the iframe
                    <iframe src="https://www.youtube.com/embed/wArETCVkS4g" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen" style="background:green"></iframe>this is after the iframe
                    <iframe src="https://www.youtube.com/embed/wArETCVkS4g" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen" style="background:green"></iframe>
                    ok wow this is cool
                    """
        
        let mutableAttributedString = NSMutableAttributedString(string: html)
        
        let iframes = html.ranges(of: "<iframe(.*?)</iframe>", options: .regularExpression).map{html[$0]}
        
        for iframe in iframes.reversed() {
            let iframeView = IframeWebView(frame: CGRect(x: 20, y: 20, width: 100, height: 70))
            iframeView.loadIframeString(iframe: String(iframe))
            let subviewTextAttachment = SubviewTextAttachment(view: iframeView)
            let attributedString = NSAttributedString(attachment: subviewTextAttachment)
            let iframeRange = iframe.startIndex..<iframe.endIndex
            mutableAttributedString.replaceCharacters(in: NSRange(iframeRange, in: html), with: attributedString)
        }
        
        textView.attributedText = mutableAttributedString
        
        
        
        let html2 = """
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
       // var iframeView = IframeWebView(html: html)
    }

}
