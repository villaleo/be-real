//
//  PostCell.swift
//  BeRealClone
//
//  Created by Leonardo Villalobos on 3/6/23.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    private var imageDataRequest: DataRequest?

    func configure(with post: Post) {
        if let user = post.user {
            usernameLabel.text = user.username
        }
        
        if let imageFile = post.imageFile,
            let imageUrl = imageFile.url {
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    self?.postImageView.image = image
                    UIImageView.roundCorners(for: self?.postImageView)
                case .failure(let error):
                    fatalError("\(error.localizedDescription)")
                    break
                }
            }
        }
        captionLabel.text = post.caption
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        
        let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffect.frame = self.postImageView.bounds
        if let currentUser = User.current,
            let lastPostedDate = currentUser.lastPostedDate,
            let postCreatedDate = post.createdAt,
            let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour
        {
            blurEffect.isHidden = abs(diffHours) < 24
        } else {
            blurEffect.isHidden = false
        }
        self.postImageView.addSubview(blurEffect)
    }
    
    // MARK: Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension UIImageView {
    static func roundCorners(for image: UIImageView?) {
        if let image = image {
            image.layer.cornerRadius = 15
            image.clipsToBounds = true
            return
        }
    }
}
