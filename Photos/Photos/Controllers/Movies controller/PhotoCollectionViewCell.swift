//
//  PhotoCollectionViewCell.swift
//  TMDb
//
//  Created by Krutika on 2022-05-29.
//

import Foundation
import UIKit
class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    func loadImage(_ downloadURL: String) {
        //enchancement can be done using caching the image instead loading all over again
        guard let url = URL(string:downloadURL) else { return  }
        self.imageLoadingIndicator.startAnimating()
        NetworkManager.shared.httpGet(url: url) { data, error in
                DispatchQueue.main.async {
                    var image: UIImage!
                    if let data = data {
                        image = UIImage(data: data)
                    }else {
                            //There is error loading image
                        image = UIImage(systemName: "xmark.octagon.fill")
                    }
                    self.imageView.image = image
                    self.imageLoadingIndicator.stopAnimating()
                }
            }
    }
}
