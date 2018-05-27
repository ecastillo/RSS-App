//
//  dummyData.swift
//  RSS App
//
//  Created by Eric Castillo on 5/26/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

func dummyArticles() -> [Article] {
    var articles = [Article]()
    
    let articleWithNoImages = Article()
    let bundle = Bundle.main
    
    let path = bundle.path(forResource: "noImagesInContent", ofType: "html")
    try! articleWithNoImages.content = String(contentsOfFile: path!)
    articles.append(articleWithNoImages)
    
    return articles
}
