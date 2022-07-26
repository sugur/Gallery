//
//  PhotoTableViewCell.swift
//  Test
//
//  Created by Sophia Tang on 2022/5/10.
//

import Foundation
import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var messageLabel = UILabel()
    var typeImageView: UIImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.red
        
        
               
               typeImageView.translatesAutoresizingMaskIntoConstraints = false
               self.addSubview(typeImageView)
               self.addConstraints([
                NSLayoutConstraint(item: typeImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -40),
                NSLayoutConstraint(item: typeImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 40),
                NSLayoutConstraint(item: typeImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10),
                NSLayoutConstraint(item: typeImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10),
//                   NSLayoutConstraint(item: typeImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0,constant:40),
//                   NSLayoutConstraint(item: typeImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (deviceImage?.size.height)!)
//                   ])
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont(name: "ArialMT", size: 14)
        timeLabel.textColor = UIColor.black
        timeLabel.textAlignment = NSTextAlignment.right
        self.timeLabel.numberOfLines = 1
        timeLabel.layer.masksToBounds = false
        self.addSubview(timeLabel)
        self.addConstraints([
            NSLayoutConstraint(item: timeLabel, attribute: .left, relatedBy: .equal, toItem: self.typeImageView, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: timeLabel, attribute: .top, relatedBy: .equal, toItem: self.typeImageView, attribute: .top, multiplier: 1.0, constant: 10),
        ])
        timeLabel.text = "00:00:00 PM"
        timeLabel.sizeToFit()
        
       
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
