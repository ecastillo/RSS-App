//
//  Feed.swift
//  RSS App
//
//  Created by Eric Castillo on 5/27/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

class Feed {
    var url: URL
    var name: String?
    var articles = [Article]()
    
    init(feedURL: URL) {
        url = feedURL
    }
}
