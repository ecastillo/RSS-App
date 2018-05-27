//
//  Article.swift
//  RSS App
//
//  Created by Eric Castillo on 5/26/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import UIKit
import FeedKit
import SwiftSoup

class Article {
    var url: URL?
    var title: String?
    var date: Date?
    var featuredImageURL: URL?
    var content: String?
    
    init() {
        url = URL(string: "http://example.com")
        title = "Sample Article"
        date = Date()
        featuredImageURL = URL(string: "http://placehold.it/600x600")
        content = "Sample article content goes here."
    }
    
    init(item: RSSFeedItem) {
        if let link = item.link {
            url = URL(string: link)
        }
        title = item.title
        date = item.pubDate
        if let description = item.description {
            content = description
            do {
                if let imgSrc = try SwiftSoup.parse(description).select("img").first()?.attr("src") {
                    featuredImageURL = URL(string: imgSrc)!
                }
            } catch Exception.Error(let type, let message) {
                print(message)
            } catch {
                print("error")
            }
        }
    }

}
