//
//  FeedItemController.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit
import SDWebImage

class FeedItemController: UIViewController {
    
    //Текущая новость
    var feedItem : FeedItem?
    
    @IBOutlet var FeedView: SingleFeedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Представление новости
        FeedView.setFeedInfo(FeedItem: feedItem)
        
        //Установка источника новости
        self.title = feedItem?.source
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}