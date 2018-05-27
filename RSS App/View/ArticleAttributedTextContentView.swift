//
//  ArticleAttributedTextContentView.swift
//  RSS App
//
//  Created by Eric Castillo on 5/25/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import DTCoreText

class ArticleAttributedTextContentView: DTAttributedTextContentView {
    
    override var bounds: CGRect {
        didSet {
            print("bounds were set!")
            attributedString.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, attributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (attachment, range, idk) in
                if let imageAttachment = attachment as? DTImageTextAttachment {
                    let aspectRatio = imageAttachment.originalSize.width / imageAttachment.originalSize.height
                    let newWidth = min(imageAttachment.originalSize.width, self.frame.width)
                    imageAttachment.displaySize = CGSize(width: newWidth, height: newWidth / aspectRatio)
                } else if let iframeAttachment = attachment as? DTIframeTextAttachment {
                    let aspectRatio = iframeAttachment.originalSize.width / iframeAttachment.originalSize.height
                    iframeAttachment.displaySize = CGSize(width: self.frame.width, height: self.frame.width / aspectRatio)
                }
            }
            print("bounds done set!")
        }
    }
    
    
    
}
