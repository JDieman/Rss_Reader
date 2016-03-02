//
//  SingleFeedView.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class SingleFeedView: UIView {
    
    @IBOutlet weak var FeedImage: UIImageView!
    @IBOutlet weak var FeedTitle: UILabel!
    
    @IBOutlet weak var FeedText: UILabel!
    
    //Установка информации о новости
    func setFeedInfo(FeedItem feedItem: FeedItem?){
        
        //FeedText.lineBreakMode = .ByWordWrapping
        FeedTitle.lineBreakMode = .ByWordWrapping
        FeedImage.clipsToBounds = true
        
        FeedTitle.text = feedItem?.title ?? ""
        FeedText.text = feedItem?.text ?? ""
        
        //Проверяем наличие изображения
        if let image = feedItem?.image {
            FeedImage.contentMode = .ScaleAspectFill
            FeedImage?.sd_setImageWithURL(image)
        }
    }
}

