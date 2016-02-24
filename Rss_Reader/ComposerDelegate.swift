//
//  ComposerDelegate.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import Foundation

//Делегат для передачи отсортированного массива новостей и для оповещения контроллера об ошибках
protocol ComposerDelegate : class {
    
    func didloadSortedItemsArray(feedItems: [FeedItem])
    func didFailWithErrorMessage(message: String)
    
}

class FeedComposer : RssServiceDelegate {
    
    weak var delegate : ComposerDelegate?
    
    //Количество источников новостей
    var numberOfSources : Int?
    
    //Номер текущего источника
    var currentSource : Int = 0
    
    //Массив новостей
    var feedItems = [FeedItem]()
    
    required init(Delegate delegate: ComposerDelegate){
        
        self.delegate = delegate
        
    }
    
    //Загрузка новостей
    func findItems(Sources sources: [String]){
        
        //Установка количства источников
        numberOfSources = sources.count
        
        //Запуск парсера для каждого источника
        for var stringURL in sources {
            
            if let address = NSURL(string: stringURL) {
                
                let rssService = RssService()
                rssService.delegate = self
                rssService.parse(Url: address)
                
            }
        }
    }
    
    //Компановка единого массива новостей из разных источников
    func composeFeedArray(feedItems: [FeedItem]){
        
        //Добавление новостей из текущего источника
        self.feedItems += feedItems
        
        //Проверяем не кончились ли источники
        if currentSource == numberOfSources {
            
            //Сортируем новости
            self.feedItems.sortInPlace(compareFeedItems)
            
            //Оповещаем контроллер о готовности массива с новостями
            delegate?.didloadSortedItemsArray(self.feedItems)
            
        }
        
    }
    
    //Сортировка новостей
    func compareFeedItems(FeedItem1 feedItem1: FeedItem, FeedItem2 feedItem2: FeedItem) -> Bool {
        
        return compareDatesDescending(Date1: feedItem1.date!, Date2: feedItem2.date!)
        
    }
    //Сортировка элементов по дате
    func compareDatesDescending(Date1 date1: NSDate, Date2 date2: NSDate) -> Bool {
        
        return date1.compare(date2) == NSComparisonResult.OrderedDescending ? true : false
        
    }
    
    //Принимаем неотсортированный массив от одного источника RssService
    func didloadItemsArray(feedItems: [FeedItem]) {
        
        //Увеличиваем значение текущего источника
        currentSource++
        
        //Компановка в единый массив
        composeFeedArray(feedItems)
        
    }
    
    //Принимаем сообщения об ошибках от RssService
    func didFailWithErrorMessage(message: String){
        
        delegate?.didFailWithErrorMessage(message)
        
    }
    
}