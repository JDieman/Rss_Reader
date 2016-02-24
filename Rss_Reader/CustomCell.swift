//
//  CustomCell.swift
//  Rss_Reader
//
//  Created by Dmitry on 24.02.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var Cell: CustomCell!
    
    @IBOutlet weak var FeedItemTitle: UILabel!
    
    @IBOutlet weak var FeedItemSource: UILabel!
    
    @IBOutlet weak var FeedItemImage: UIImageView!
    
    //Новость для данной ячейки
    var feedItem : FeedItem?
    
    //Изображение новостей по-умолчанию
    let placeholderImage = UIImage(named: "rss-logo.png")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FeedItemImage.contentMode = .ScaleAspectFill
        FeedItemImage.clipsToBounds = true
        FeedItemImage.image = placeholderImage
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //Установка информации о новости
    func setFeedInfo(FeedItem feedItem: FeedItem){
        self.feedItem = feedItem
        FeedItemTitle.text = feedItem.title
        FeedItemSource.text = feedItem.source
        
        //Установка изображения
        if let imageURL = feedItem.image {
            setImage(Url: imageURL)
        }
    }
    
    func setImage(Url url: NSURL){
        FeedItemImage.sd_setImageWithURL(url, placeholderImage: placeholderImage)
    }
}

