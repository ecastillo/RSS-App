//
//  IframeWebView.swift
//  RSS App
//
//  Created by Eric Castillo on 5/19/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup

class IframeWebView: WKWebView {
    
    var aspectRatio: CGFloat?
    //var html: String
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    
    func loadIframeString(iframe: String) {
        do {
            let doc: Document = try SwiftSoup.parse(iframe)
            let iframe: Element = try! doc.select("iframe").first()!
            let iframeWidth: String = try! iframe.attr("width")
            let iframeHeight: String = try! iframe.attr("height")
            
            print("iframe built-in width: \(iframeWidth)")
            
            if let iframeWidthNum = NumberFormatter().number(from: iframeWidth),
                let iframeHeightNum = NumberFormatter().number(from: iframeHeight) {
                aspectRatio = CGFloat(truncating: iframeWidthNum) / CGFloat(truncating: iframeHeightNum)
            } else {
                aspectRatio = 1
            }
            
            print("aspect ratio: \(aspectRatio)")
            
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        //self.html = html
        let prefix = """
                    <html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body style="margin:0">
                    """
        let suffix = """
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
        self.loadHTMLString(prefix+iframe+suffix, baseURL: nil)
    }
    
    required init?(coder: NSCoder) {
        //self.html = ""
        super.init(coder: coder)
    }
    
    override var bounds: CGRect {
        didSet {
            print("bounds were set of IframeWebView!")
            self.evaluateJavaScript("window.dispatchEvent(new Event('resize'))") { (result, error) in
                if error != nil {
                    print(result)
                }
            }
        }
    }
    
}
