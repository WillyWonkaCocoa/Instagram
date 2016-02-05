//
//  PhotosViewController.swift
//  Instagram
//
//  Created by wgao1 on 2/4/16.
//  Copyright © 2016 William Gao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var photos: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.photos = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    
    
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let photos = photos {
            return photos.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let photo = photos![indexPath.row]
        
        let user = photo["user"]
        let userName = user!["username"] as! String
        let profilePicUrl = NSURL(string: user!["profile_picture"] as! String)
        cell.profilePic.setImageWithURL(profilePicUrl!)
        
        let fullName = user!["full_name"] as! String
        cell.nameLabel.text = userName
        
        let likes = photo["likes"]
        let numOfLikes = likes!["count"] as! Int
        cell.likesLabel.text = "\(String(numOfLikes)) likes"
        print("\(String(numOfLikes)) likes")
        
        let photoURL = photo["images"]
        let standardResolution = photoURL!["standard_resolution"]
        let standardURL = standardResolution!!["url"] as! String
        
        let imageURL = NSURL(string: standardURL)
        //cell.photoView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
//        cell.photoView.clipsToBounds = true
//        cell.photoView.layer.cornerRadius = 15;
//        cell.photoView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
//        cell.photoView.layer.borderWidth = 1;
        
        cell.photoView.setImageWithURL(imageURL!)
       
       
        
        
        let location = photo["location"]
        if let locationName = location?["name"]{
            cell.locationLabel.text = locationName as! String
            return cell
        }else{
            let locationName = ""
            cell.locationLabel.text = locationName as! String
            return cell
        }
       
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
