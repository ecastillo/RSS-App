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

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var feeds = [Feed]()
    //var feedURL: String =  "http://eflorenzano.com/atom.xml" //"http://brack3t.com/feeds/all.atom.xml" //"http://feeds.macrumors.com/MacRumors-All" //"https://refind.com/chrismessina.json"
    var selectedArticle: Article?
    
    @IBOutlet weak var feedsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feed1 = Feed(feedURL: URL(string: "http://feeds.macrumors.com/MacRumors-All")!)
        feeds.append(feed1)
        let feed2 = Feed(feedURL: URL(string: "http://brack3t.com/feeds/all.atom.xml")!)
        feeds.append(feed2)
        let feed3 = Feed(feedURL: URL(string: "http://eflorenzano.com/atom.xml")!)
        feeds.append(feed3)
        
        feedsTableView.delegate = self
        feedsTableView.dataSource = self
        
        //articles = dummyArticles()
        loadArticles()
    }
    
    func loadArticles() {
        
        for (i, zfeed) in feeds.enumerated() {
            if let parser = FeedParser(URL: zfeed.url) { // or FeedParser(data: data)
                // Parse asynchronously, not to block the UI.
                parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                    var zarticles = [Article]()
                    switch result {
                    case let .atom(feed):       // Atom Syndication Format Feed Model
                        print("atom obtained!")
                        for entry in feed.entries! {
                            let article = Article(entry: entry)
                            zarticles.append(article)
                        }
                        zfeed.articles = zarticles
                    case let .rss(feed):        // Really Simple Syndication Feed Model
                        print("rss obtained!")
                        for item in feed.items! {
                            let article = Article(item: item)
                            zarticles.append(article)
                        }
                        zfeed.articles = zarticles
                    case let .json(feed):       // JSON Feed Model
                        print("json obtained!")
                        for item in feed.items ?? [] {
                            let article = Article(item: item)
                            zarticles.append(article)
                        }
                        zfeed.articles = zarticles
                    case let .failure(error):
                        print(error)
                    }
                    // Do your thing, then back to the Main thread
                    DispatchQueue.main.async {
                        // ..and update the UI
                        self.feedsTableView.reloadData()
                    }
                }
            } else {
                print("error parsing feed URL")
            }
        }
        
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return feeds[section].url.absoluteString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedRow
        cell.feedCollectionView.delegate = self
        cell.tag = indexPath.section
        print("cell tag: \(indexPath.section)")
        cell.articles = feeds[indexPath.section].articles
        print("articles count: \(feeds[indexPath.section].articles.count)")
        cell.feedCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: feedsTableView.frame.width, height: UIFont.systemFont(ofSize: 12, weight: .light).lineHeight))
        headerLabel.text = feeds[section].url.absoluteString
        headerLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIFont.systemFont(ofSize: 12, weight: .light).lineHeight
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected tableview at indexpath.row: \(indexPath.row)")
    }
    
    
    
    //MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionview item was selected")
        selectedArticle = feeds[(collectionView.cellForItem(at: indexPath)?.tag)!].articles[indexPath.row]
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleViewController
        destinationVC.article = selectedArticle
    }

}

