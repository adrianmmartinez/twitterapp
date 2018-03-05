//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    var time: String = ""
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userImageView.layer.cornerRadius = 39.0
            userImageView.clipsToBounds = true
            reloadData()
        }
    }
    
    func reloadData(){
        tweetTextLabel.text = tweet.text
        let url = URL(string: tweet.user.profileImage!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        userImageView.image = UIImage(data: data!)
        favoriteCountLabel.text = "\(tweet.favoriteCount!)"
        retweetCountLabel.text = String(describing: tweet.retweetCount)
        nameLabel.text = tweet.user.name
        usernameLabel.text = tweet.user.screenName
        setTimeSinceTweet()
        setFavIcon()
    }
    
    func setFavIcon() {
        if(tweet.favorited == true){
            self.favButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/favor-icon-red.imageset/favor-icon-red.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.favButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/favor-icon.imageset/favor-icon.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    func setTimeSinceTweet(){
        let timeArr = tweet.createdAtString.components(separatedBy: ":")
        if(Int(timeArr[0])! > 0){
            let intArr = Array(timeArr[0])
            if(intArr[0] == "0"){
                time = String(describing: intArr[1]) + "hr"
            }
            else{
                time = timeArr[0] + "hr"
            }
        } else if(Int(timeArr[1])! > 0){
            let intArr = Array(timeArr[1])
            if(intArr[0] == "0"){
                time = String(describing: intArr[1]) + "min"
            }
            else{
                time = timeArr[1] + "min"
            }
        } else {
            let intArr = Array(timeArr[2])
            if(intArr[0] == "0"){
                time = String(describing: intArr[1]) + "sec"
            }
            else{
                time = timeArr[2] + "sec"
            }
        }
        timeLabel.text = time
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if(tweet.favorited == true){
            APIManager.shared.unfavorite(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    tweet.favorited = false
                    tweet.favoriteCount! -= 1
                    self.favButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/favor-icon.imageset/favor-icon.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            })
        } else {
            APIManager.shared.favorite(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    tweet.favorited = true
                    tweet.favoriteCount! += 1
                    self.favButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/favor-icon-red.imageset/favor-icon-red.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            })
        }
        reloadData()
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if(tweet.retweeted == true){
            tweet.retweeted = false
            tweet.retweetCount -= 1
            retweetButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/retweet-icon.imageset/retweet-icon.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            APIManager.shared.unretweet(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            })
        } else {
            tweet.retweeted = true
            tweet.retweetCount += 1
            retweetButton.setImage(UIImage(named: "/Users/adrianmartinez/Desktop/Spring2018/CST495/twitter/twitter_alamofire_demo/Assets.xcassets/retweet-icon-green.imageset/retweet-icon-green.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            APIManager.shared.retweet(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            })
        }
        
    }
    
    
}
