//
//  PhotoTableView.swift
//  Test
//
//  Created by Sophia Tang on 2022/5/10.
//

import Foundation
import UIKit
class PhotoTableView: UITableView,  UITableViewDelegate, UITableViewDataSource {
    
    //Define Cell Height
    var cellHeight: CGFloat = 0
    
    
    var items:  [Gallery] = []
    
    
    var sectionsRowsDic = [Int:Int]()        //[Section : Rows]      ex:[ 0 : 2 ]
    var sectionsDate = [Int: String]()       //[Section : Date]      ex:[ 0 : 20151102 ]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        MyLog("self.items.count \(self.items.count)")
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.selectionStyle = .none
        
        
        
        cell.messageLabel.text = self.items[indexPath.row].title
        
        
        
        let startTimeDouble = Double (self.items[indexPath.row].datetime)
        let startTimeString = getDateFromTimeStamp(timeStamp: startTimeDouble) as NSString
        let newDateTime = startTimeString.substring(with: NSMakeRange(0, 8))
        let newTimeToDisplay = startTimeString.substring(with: NSMakeRange(9, 8))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = Date()
        let yesterday = today.addingTimeInterval(-60*60*24)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: newDateTime)
        {
            if (Calendar.current as NSCalendar).compare(date, to: today, toUnitGranularity: .year) != ComparisonResult.orderedSame
            {
                cell.timeLabel.text = newDateTime
            }
            if (Calendar.current as NSCalendar).compare(date, to: today, toUnitGranularity: .day) == ComparisonResult.orderedSame
            {
                
                cell.timeLabel.text = newTimeToDisplay
                
            }
            else
            {
                cell.timeLabel.text = "newDateTime"
            }
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        if let timeDate = dateFormatter.date(from: newTimeToDisplay)
        {
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            dateFormatter.dateFormat = "hh:mm:ss a"
            let timeString = dateFormatter.string(from: timeDate)
            cell.timeLabel.text = timeString
            
            
        }
        
        MyLog("startTimeString \(startTimeString)")
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            //1.Get image from cache
            if cameraFormalName != nil
            {
                let tmpStr = cameraFormalName! + String (self.items[indexPath.row].startTime) + fileIdentifer
                //if timelineImageCache.object(forKey: cameraFormalName! + self.items[indexPath.row].fileID! + fileIdentifer) != nil
                if timelineImageCache.object(forKey: tmpStr as AnyObject) != nil
                {
                   // print("Cache")
                    DispatchQueue.main.async{
                        //cell.snapshotImage.image = timelineImageCache.object(forKey: cameraFormalName! + self.items[indexPath.row].fileID! + fileIdentifer) as? UIImage
                        cell.snapshotImage.image = timelineImageCache.object(forKey: tmpStr as AnyObject) as? UIImage
                    }
                    return
                }
                
                //2.Get image from file system
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                  let folderPath = path.stringByAppendingPathComponent("\(folderIdentifer)/" + cameraFormalName!)
                let destinationPath = folderPath.stringByAppendingPathComponent(cameraFormalName! + String (self.items[indexPath.row].startTime) + fileIdentifer + ".jpg")
                let fileManager = FileManager.default
                if (fileManager.fileExists(atPath: destinationPath))
                {
                    DispatchQueue.main.async{
                        cell.snapshotImage.image = UIImage(contentsOfFile: destinationPath)
                    }
                    return
                }
                
                
                //3.Download image form web
                if userDefaults.string(forKey: "cameraName") != nil
                {
                    if let _ =  (self.items[indexPath.row].path)
                    {
                        let fileID = String (self.items[indexPath.row].startTime )
                        //stop the previous download
                        //landscapeDisplayImageView.cancelImageRequestOperation()
                        cell.snapshotImage.cancelImageDownloadTask()
                        
                        var  URLPath:URL
                        
                   
                        let url_request = URLRequest(url: URLPath)
                       
                        
                        cell.typeImageView.setImageWith(url_request, placeholderImage: nil, success: {  (request:URLRequest,response:HTTPURLResponse?, image2:UIImage) -> Void in
                            let smallImage = resizeImage(image2, toTheSize: CGSize(width: 320, height: 180))
                            let tmpStr = cameraFormalName! + fileID + fileIdentifer
                           
                            timelineImageCache.setObject(smallImage, forKey: tmpStr as AnyObject)
                            FileSystemManager.instance.saveImageToLoacl(smallImage, fileName: cameraFormalName! + fileID + fileIdentifer, folderName: "\(folderIdentifer)/" + cameraFormalName!)
                            DispatchQueue.main.async{
                              
                                cell.snapshotImage.image = timelineImageCache.object(forKey: tmpStr as AnyObject) as? UIImage
                            }
                            
                        }, failure: { (request, response, error) -> Void in
                            MyLog("TimelineTableView.swift cellForRowAtIndexPath, error = \(error)")
                        })
                    }
                    else
                    {
                        print("catch!!")
                    }
                }
                else
                {
                    DispatchQueue.main.async{
                        cell.typeImageView.image = nil
                    }
                }
            }
        }
    }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return cellHeight
        
        return 100
    }
    
    
    func calculateSectionsAndRows()
    {
        self.sectionsRowsDic.removeAll()
        self.sectionsDate.removeAll()
        
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func calculateIndex(_ indexPath: IndexPath) -> Int
    {
        let section = indexPath.section
        var index: Int = 0
        
        for i in 0 ..< section
        {
            index += sectionsRowsDic[i]!
        }
        
        return index
    }
    
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current//TimeZone(identifier: "Asia/Shanghai")
        dayTimePeriodFormatter.dateFormat = "yyyyMMdd HH:mm:ss.S"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
}

