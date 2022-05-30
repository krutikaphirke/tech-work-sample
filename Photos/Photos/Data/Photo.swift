import Foundation
import CoreGraphics

enum ImageType {
    case normal
    case blur(_ value:String)
    case gray
}
// MARK: - Popular
struct Photo: Codable {
    let id, author: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case downloadURL = "download_url"
    }

}
