//
//  PhotoViewController.swift
//  Test
//
//  Created by wei on 2022/5/8.
//

import Foundation
import UIKit

import Combine

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

class  PhotoViewController: UIViewController {
    
    lazy var imgurAPI: ImgurAPI = {
        return ImgurAPI()
    }()
    
    let toplineView = UIView ()
    var galleryItems: [Gallery] = []
    var photoLoadingIndicator = UIActivityIndicatorView()
    
    var photoTableView: PhotoTableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.galleryItems = []
        
        DispatchQueue.main.async{
            self.photoTableView.sectionsDate.removeAll()
            self.photoTableView.sectionsRowsDic.removeAll()
            
            
            self.photoTableView.items.removeAll()
            self.photoTableView.reloadData()
            
            DispatchQueue.global(qos: .default).async {
                
                self.loadPhotoList()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Event List
        photoTableView = PhotoTableView()
        photoTableView.backgroundColor = UIColor.blue
        photoTableView.delegate = photoTableView
        photoTableView.dataSource = photoTableView
        photoTableView.translatesAutoresizingMaskIntoConstraints = false
        photoTableView.showsHorizontalScrollIndicator = false
     
        photoTableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "cell")
   
        self.view.addSubview(photoTableView)
      
        self.view.addConstraints( [
            NSLayoutConstraint(item: self.photoTableView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant:0),
            NSLayoutConstraint(item: self.photoTableView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.photoTableView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -44),
            NSLayoutConstraint(item: self.photoTableView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
        ])

        photoTableView.estimatedRowHeight = 100
        photoTableView.rowHeight = UITableView.automaticDimension
        photoTableView.layoutIfNeeded()

        if #available(iOS 11.0, *) {
            photoTableView.contentInsetAdjustmentBehavior = .never
            photoTableView.estimatedRowHeight = 0;
            photoTableView.estimatedSectionHeaderHeight = 0;
            photoTableView.estimatedSectionFooterHeight = 0;
        } else {
            //            automaticallyAdjustsScrollViewInsets = false;
        }
        
       
        
        self.photoTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func loadPhotoList()
    {
        
       let result  = RequestManager.instance.SearchGalleryRequest(page: 1, sort: RequestManager.GallerySearchSortingType.time, query: "q")
        
//        if (result.success)
//        {
            self.didFinishgetGalleryList(result.2!)

//        }
    }

    open func didFinishgetGalleryList(_ newItem: [Gallery])
    {
        MyLog("didFinishgetGalleryList \(newItem.count)")
        self.galleryItems = newItem
      
        photoTableView.sectionsDate.removeAll()
        photoTableView.sectionsRowsDic.removeAll()
        photoTableView.items.removeAll()
        
        photoTableView.items = galleryItems
        
        DispatchQueue.main.async{
            self.photoLoadingIndicator.stopAnimating()
            self.photoLoadingIndicator.removeFromSuperview()
            
            
            //Reload the data
            self.photoTableView.reloadData()
          
            
        }
    }
   
}

