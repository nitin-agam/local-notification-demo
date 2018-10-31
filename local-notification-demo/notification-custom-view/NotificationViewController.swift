//
//  NotificationViewController.swift
//  notification-custom-view
//
//  Created by Nitin A on 31/10/18.
//  Copyright © 2018 Nitin Aggarwal. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVFoundation

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var videoPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        preferredContentSize = CGSize(width: view.frame.width, height: view.frame.width - 80)
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        
        guard let attachment = content.attachments.first else { return }
        
        if attachment.url.startAccessingSecurityScopedResource() {
            if let imageData = try? Data(contentsOf: attachment.url) {
                if let image = UIImage(data: imageData) {
                    imageView.image = image
                }
            }
        }
        attachment.url.stopAccessingSecurityScopedResource()
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        if response.actionIdentifier == "play_action" {
            let content = response.notification.request.content
            guard let attachment = content.attachments.first else { return }
            
            if attachment.url.startAccessingSecurityScopedResource() {
                let item = AVPlayerItem(url: attachment.url)
                self.videoPlayer = AVPlayer(playerItem: item)
                
                self.imageView.isHidden = true
                let playerLayer = AVPlayerLayer(player: self.videoPlayer)
                playerLayer.frame = self.view.layer.bounds
                self.view.layer.addSublayer(playerLayer)
                self.videoPlayer?.play()
            }
            attachment.url.stopAccessingSecurityScopedResource()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.videoPlayer?.pause()
                self.videoPlayer = nil
            }
            completion(.doNotDismiss)
            
        } else if response.actionIdentifier == "comment_action" {
            if let commentText = response as? UNTextInputNotificationResponse {
                self.subtitleLabel.text = commentText.userText
            }
            completion(.doNotDismiss)
        }
    }
}

