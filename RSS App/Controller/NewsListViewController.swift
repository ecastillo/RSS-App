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
    
    var feeds = [String]()
    //var feedURL: String =  "http://eflorenzano.com/atom.xml" //"http://brack3t.com/feeds/all.atom.xml" //"http://feeds.macrumors.com/MacRumors-All" //"https://refind.com/chrismessina.json"
    var articles = [[Article]]()
    var selectedArticle: Article?
    
    @IBOutlet weak var feedsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feeds.append("http://feeds.macrumors.com/MacRumors-All")
        articles.append([Article]())
        feeds.append("http://brack3t.com/feeds/all.atom.xml")
        articles.append([Article]())
        feeds.append("http://eflorenzano.com/atom.xml")
        articles.append([Article]())
        
        feedsTableView.delegate = self
        feedsTableView.dataSource = self
        
        //articles = dummyArticles()
        loadArticles()
    }
    
    func loadArticles() {
        
        for (i, feed) in feeds.enumerated() {
            let feedURL = URL(string: feed)!
            if let parser = FeedParser(URL: feedURL) { // or FeedParser(data: data)
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
                        self.articles[i] = zarticles
                    case let .rss(feed):        // Really Simple Syndication Feed Model
                        print("rss obtained!")
                        for item in feed.items! {
                            let article = Article(item: item)
                            zarticles.append(article)
                        }
                        self.articles[i] = zarticles
                    case let .json(feed):       // JSON Feed Model
                        print("json obtained!")
                        for item in feed.items ?? [] {
                            let article = Article(item: item)
                            zarticles.append(article)
                        }
                        self.articles[i] = zarticles
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
        return feeds[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.count > 0 {
            print("section: \(section)")
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedRow
        cell.feedCollectionView.delegate = self
        cell.tag = indexPath.section
        print("cell tag: \(indexPath.section)")
        cell.articles = articles[indexPath.section]
        print("articles count: \(articles[indexPath.section].count)")
        cell.feedCollectionView.reloadData()
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected tableview at indexpath.row: \(indexPath.row)")
    }
    
    
    
    //MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionview item was selected")
        selectedArticle = articles[(collectionView.cellForItem(at: indexPath)?.tag)!][indexPath.row]
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("mmmmmmmm")
        let destinationVC = segue.destination as! ArticleViewController
        //if let indexPath = articleCollectionView.indexPathsForSelectedItems {
            destinationVC.article = selectedArticle
        //}
    }

}

