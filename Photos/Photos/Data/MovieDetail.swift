import UIKit

struct PhotoDetail: Codable {
    let id, author: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case downloadURL = "download_url"
    }
    var normalImagURL: String {
        return Endpoint.normalPhoto(self.id, withWidth: String(format: "%.0f", UIScreen.main.bounds.width))
    }
    var blurImageURL: String {
        return Endpoint.normalPhoto(self.id, withWidth: String(format: "%.0f", UIScreen.main.bounds.width),withtype: "blur=5")
    }
    var grayscaleImageURL: String {
        return Endpoint.normalPhoto(self.id, withWidth: String(format: "%.0f", UIScreen.main.bounds.width),withtype: "grayscale")
       
    }
}
