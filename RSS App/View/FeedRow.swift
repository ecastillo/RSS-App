//
//  FeedRow.swift
//  RSS App
//
//  Created by Eric Castillo on 5/27/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class FeedRow: UITableViewCell, UICollectionViewDataSource {
    
    var articles: [Article]?
    var selectedArticle: Article?
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("articles in collectionView: \(articles!.count)")
        return articles!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "articleCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCollectionViewCell
        cell.tag = tag
        let article = articles![indexPath.row]
        cell.title.text = article.title
        cell.date.text = article.date?.timeAgoSinceNow
        let articleImageURL = article.featuredImageURL
        cell.image.sd_setImage(with: articleImageURL, placeholderImage: nil)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }

}
