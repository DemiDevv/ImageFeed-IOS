//
//  ImagesListCell.swift
//  ImageFeed-IOS
//
//  Created by Demain Petropavlov on 09.06.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
