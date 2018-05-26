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
    var articlesArray = [FeedKit.RSSFeedItem]()
    var articleImageURLs = [URL]()
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticles()
        
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
                        self.articlesArray = feed.items!
                        do {
                            for article in self.articlesArray {
                                let doc: Document = try SwiftSoup.parse(article.description!)
                                let img: Element = try! doc.select("img").first()!
                                let imgSrc: String = try! img.attr("src")
                                self.articleImageURLs.append(URL(string: imgSrc)!)
                            }
                        } catch Exception.Error(let type, let message) {
                            print(message)
                        } catch {
                            print("error")
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
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCollectionViewCell
        
        let selectedArticle = articlesArray[indexPath.row]
        cell.title.text = selectedArticle.title
        cell.date.text = selectedArticle.pubDate?.timeAgoSinceNow
        
        do {
            //if(Int((imgz?.size.width)!) > 200) {
            let articleImageURL = articleImageURLs[indexPath.row]
            cell.image.sd_setImage(with: articleImageURL, placeholderImage: nil)
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        
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
            destinationVC.article = articlesArray[indexPath[0].row]
            //destinationVC.featuredImage.image =
        }
    }

}

