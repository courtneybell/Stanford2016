//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Bell, Courtney on 7/31/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {
    
    var tweets = [Array<Tweet>](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private func searchForTweets(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#stanford"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    


}
