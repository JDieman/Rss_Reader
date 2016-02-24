//
//  FeedTableViewController.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//
import MWFeedParser
import UIKit

class FeedTableViewController: UITableViewController, ComposerDelegate {
    
    //Отсортированный массив с новостями
    var feedItems = [FeedItem]()
    var numberOfSectionsInTableView = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "News"
        
        //Создание класса для компановки новостей, подписываемя на изменения
        let composer = FeedComposer(Delegate: self)
        
        //Запускаем поиск новостей
        composer.findItems(Sources: Source.links)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSectionsInTableView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        let feedItem = feedItems[indexPath.row]
        
        ////Представление ячейки
        cell.setFeedInfo(FeedItem: feedItem)
        return cell
    }
    
    //Переход к расширенному виду
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let cell = sender as? CustomCell {
            
            //let controller = segue.destinationViewController as! FeedItemController
            
            //Передача информации о новости
            //controller.feedItem = cell.feedItem
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("segue", sender: tableView.cellForRowAtIndexPath(indexPath))
        
    }
    //Принимаем отсортированный массив новостей от FeedComposer
    func didloadSortedItemsArray(feedItems: [FeedItem]) {
        self.feedItems = feedItems
        self.tableView.reloadData()
    }
    
    //Принимаем сообщения об ошибках от FeedComposer
    func didFailWithErrorMessage(message: String){
        
        let alertController: UIAlertController = UIAlertController.init(title: "Error", message: message, preferredStyle: .Alert)
        let ok: UIAlertAction = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
        alertController.addAction(ok)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}