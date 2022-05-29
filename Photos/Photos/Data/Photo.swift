import CoreGraphics


// MARK: - Popular
struct Photo: Codable {
    let id: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case downloadURL = "download_url"
    }
    
    func normalImagURL( width: CGFloat) -> String {
        return Endpoint.normalPhoto(self.id, withWidth: String(format: "%.0f", width), height: String(format: "%.0f", width))
    }
}
