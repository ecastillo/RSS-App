//
//  testViewController.swift
//  RSS App
//
//  Created by Eric Castillo on 5/19/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let html = """
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
