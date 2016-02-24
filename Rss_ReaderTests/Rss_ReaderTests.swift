//
//  Rss_ReaderTests.swift
//  Rss_ReaderTests
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import XCTest
@testable import Rss_Reader

class Rss_ReaderTests: XCTestCase, RssServiceDelegate {
    
    //Парсер новостей
    let rssService = RssService()
    
    override func setUp() {
        super.setUp()
        
        rssService.delegate = self
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    //Тестирование парсера для lenta.ru
    func testParseForLenta() {
        
        rssService.parse(Url: NSURL(string: "http://lenta.ru/rss")!)
        
    }
    
    //Тестирование парсера для gazeta.ru
    func testParseForGazeta() {
        
        rssService.parse(Url: NSURL(string: "http://www.gazeta.ru/export/rss/lenta.xml")!)
        
    }
    
    //Проверка сортировки новостей по дате
    func testCompare(){
        
        let feedComposer = FeedComposer(Delegate: mockComposerDelegate())
        let mockArray = [FeedItem(), FeedItem()]
        
        //Добавляем элементы с неправильной последовательностью
        mockArray[0].date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])!
        mockArray[1].date = NSDate()
        
        //Вызываем тестируемый метод сортировки
        let sortedArray = mockArray.sort(feedComposer.compareFeedItems)
        
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dayFromMock = (calendar?.component(NSCalendarUnit.Day, fromDate: mockArray[0].date!))!
        let dayFromSorted = (calendar?.component(NSCalendarUnit.Day, fromDate: sortedArray[0].date!))!
        
        XCTAssertLessThan(dayFromMock, dayFromSorted)
    }
    
    func didloadItemsArray(feedItems: [FeedItem]) {
        
        //Тестируем первые 10 новостей
        for var item in feedItems[0...10] {
            
            //Заголовок новости должен существовать
            XCTAssertNotNil(item.title)
            
            //Текст новости должен существовать
            XCTAssertNotNil(item.text)
            
            //Дата новости должна существовать
            XCTAssertNotNil(item.date)
            
        }
    }
    
    
    
    func didFailWithErrorMessage(message: String){
        
    }
}

class mockComposerDelegate : ComposerDelegate {
    func didloadSortedItemsArray(feedItems: [FeedItem]) {}
    func didFailWithErrorMessage(message: String) {}
}
