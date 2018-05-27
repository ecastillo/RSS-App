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
    let bundle = Bundle.main
    var path: String?
    
    let noFeaturedImage = Article()
    noFeaturedImage.title = "No Featured Image"
    noFeaturedImage.featuredImageURL = nil
    articles.append(noFeaturedImage)
    
    let smallFeaturedImage = Article()
    smallFeaturedImage.title = "Small Featured Image"
    smallFeaturedImage.featuredImageURL = URL(string: "http://placehold.it/50x50")
    articles.append(smallFeaturedImage)
    
    let longTitle = Article()
    longTitle.title = "Long Title Integer posuere erat a ante venenatis dapibus posuere velit aliquet curabitur blandit tempus porttitor."
    articles.append(longTitle)
    
    let longDomain = Article()
    longDomain.title = "Long Domain"
    longDomain.url = URL(string: "http://thisisaverlylongdomainnamethatprobablywontfit.com")
    articles.append(longDomain)
    
    let smallImageInContent = Article()
    smallImageInContent.title = "Small Image in Content"
    path = bundle.path(forResource: "smallImageInContent", ofType: "html")
    try! smallImageInContent.content = String(contentsOfFile: path!)
    articles.append(smallImageInContent)
    
    let manyImages = Article()
    manyImages.title = "Many Images"
    path = bundle.path(forResource: "manyImages", ofType: "html")
    try! manyImages.content = String(contentsOfFile: path!)
    articles.append(manyImages)
    
    let imageNoWidth = Article()
    imageNoWidth.title = "Image No Width"
    path = bundle.path(forResource: "imageNoWidth", ofType: "html")
    try! imageNoWidth.content = String(contentsOfFile: path!)
    articles.append(imageNoWidth)
    
    let imageNoHeight = Article()
    imageNoHeight.title = "Image No Height"
    path = bundle.path(forResource: "imageNoHeight", ofType: "html")
    try! imageNoHeight.content = String(contentsOfFile: path!)
    articles.append(imageNoHeight)
    
    let imageNoWidthHeight = Article()
    imageNoWidthHeight.title = "Image No Width or Height"
    path = bundle.path(forResource: "imageNoWidthHeight", ofType: "html")
    try! imageNoWidthHeight.content = String(contentsOfFile: path!)
    articles.append(imageNoWidthHeight)
    
    let manyIframes = Article()
    manyIframes.title = "Many iFrames"
    path = bundle.path(forResource: "manyIframes", ofType: "html")
    try! manyIframes.content = String(contentsOfFile: path!)
    articles.append(manyIframes)
    
    let iframeNoHeight = Article()
    iframeNoHeight.title = "iFrame No Height"
    path = bundle.path(forResource: "iframeNoHeight", ofType: "html")
    try! iframeNoHeight.content = String(contentsOfFile: path!)
    articles.append(iframeNoHeight)
    
    let iframeNoWidth = Article()
    iframeNoWidth.title = "iFrame No Width"
    path = bundle.path(forResource: "iframeNoWidth", ofType: "html")
    try! iframeNoWidth.content = String(contentsOfFile: path!)
    articles.append(iframeNoWidth)
    
    let iframeNoWidthHeight = Article()
    iframeNoWidthHeight.title = "iFrame No Width or Height"
    path = bundle.path(forResource: "iframeNoWidthHeight", ofType: "html")
    try! iframeNoWidthHeight.content = String(contentsOfFile: path!)
    articles.append(iframeNoWidthHeight)
    
    let linkedImage = Article()
    linkedImage.title = "Linked Image"
    path = bundle.path(forResource: "linkedImage", ofType: "html")
    try! linkedImage.content = String(contentsOfFile: path!)
    articles.append(linkedImage)
    
    let linkEmpty = Article()
    linkEmpty.title = "Link Empty"
    path = bundle.path(forResource: "linkEmpty", ofType: "html")
    try! linkEmpty.content = String(contentsOfFile: path!)
    articles.append(linkEmpty)
    
    let linkNoHref = Article()
    linkNoHref.title = "Link No Href"
    path = bundle.path(forResource: "linkNoHref", ofType: "html")
    try! linkNoHref.content = String(contentsOfFile: path!)
    articles.append(linkNoHref)
    
    return articles
}
