//
//  RssService.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import Foundation
import MWFeedParser

//Делегат передачи массива с новостями и для оповещения компановщика новостей об ошибках при парсинге
protocol RssServiceDelegate : class {
    
    func didloadItemsArray(feedItems: [FeedItem])
    func didFailWithErrorMessage(message: String)
}

class RssService : NSObject, MWFeedParserDelegate {
    
    //Массив с новостями
    var feedItems = [FeedItem]()
    weak var delegate: RssServiceDelegate?
    
    //Название источника новостей
    var sourceTitle: String?
    
    //Адрес источника новостей
    var sourceUrl : NSURL?
    
    //Парсим новости из переданного источника
    func parse(Url url: NSURL) {
        
        sourceUrl = url
        let feedParser = MWFeedParser(feedURL: url)
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.parse()
        
    }
    
    //Окончание загрузки и парсинга новостей и передача массива в компановщик новостей
    func feedParserDidFinish(parser: MWFeedParser!) {
        
        delegate?.didloadItemsArray(feedItems)
        
    }
    
    //Установка названя источника новостей
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        
        sourceTitle = info.title
        
    }
    
    //Формирование каждой новости и добавление их к масиву feedItems
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        
        let feedItem = FeedItem()
        
        if let title = item.title {
            feedItem.title = title
        }
        
        if let content = item.summary {
            feedItem.text = content
        }
        
        if let text = item.summary {
            feedItem.text = text
        }
        
        if let date = item.date {
            feedItem.date = date
        }
        
        if let imageURL = getImage(Item: item) {
            feedItem.image = NSURL(string: String(imageURL))
        }
        
        //Если не удается определить название источника новостей, то в качестве названия использовать адрес источника
        feedItem.source = sourceTitle ?? String(sourceUrl)
        feedItems.append(feedItem)
        
    }
    
    //Проверка наличия изображения в новости
    func getImage(Item item: MWFeedItem) -> String?{
        
        if item.enclosures != nil {
            if let type = item.enclosures[0]["type"] {
                if String(type!) == "image/jpeg" {
                    if let imageURL = item.enclosures[0]["url"] {
                        return String(imageURL!)
                    }
                }
            }
        }
        return nil
    }
    
    //Отправка ошибок в компановщик новостей
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        
        delegate?.didFailWithErrorMessage(error.description)
    }
    
}