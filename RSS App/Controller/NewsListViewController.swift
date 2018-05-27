//
//  NewsListViewController.swift
//  RSS App
//
//  Created by Eric Castillo on 5/14/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import FeedKit
import SwiftSoup
import SDWebImage

class NewsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var feedURL: String = "http://feeds.macrumors.com/MacRumors-All"
    var articles = [Article]()
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articles = dummyArticles()
        //loadArticles()
        
        articleCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "articleCell")
    }
    
    func loadArticles() {
        
        let feedURL = URL(string: self.feedURL)!
        if let parser = FeedParser(URL: feedURL) { // or FeedParser(data: data)
            // Parse asynchronously, not to block the UI.
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                // Do your thing, then back to the Main thread
                DispatchQueue.main.async {
                    // ..and update the UI
                    switch result {
                    case let .atom(feed): break       // Atom Syndication Format Feed Model
                    case let .rss(feed):        // Really Simple Syndication Feed Model
                        print("rss obtained!")
                        for item in feed.items! {
                            let article = Article(item: item)
                            self.articles.append(article)
                        }
                        self.articleCollectionView.reloadData()
                    case let .json(feed):       // JSON Feed Model
                        print("json obtained!")
                    case let .failure(error):
                        print(error)
                    }
                }
            }
        } else {
            print("error parsing feed URL")
        }
        
    }
    
    
    
    //MARK: - CollectionView Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCollectionViewCell
        
        let selectedArticle = articles[indexPath.row]
        cell.title.text = selectedArticle.title
        cell.date.text = selectedArticle.date?.timeAgoSinceNow
        let articleImageURL = articles[indexPath.row].featuredImageURL
        cell.image.sd_setImage(with: articleImageURL, placeholderImage: nil)
        
        return cell
    }
    
    
    
    // MARK: - CollectionView Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleViewController
        if let indexPath = articleCollectionView.indexPathsForSelectedItems {
            destinationVC.article = articles[indexPath[0].row]
        }
    }

}

