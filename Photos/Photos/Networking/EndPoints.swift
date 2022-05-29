
import Foundation


struct Endpoint {
    var path: String
    var version = "/v2/"
    var queryItems: [URLQueryItem] = []
    
}
extension Endpoint {
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "picsum.photos"
        components.path = version + path
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

extension Endpoint {
    
    static func photoList(_ page: Int, limit: Int) -> Endpoint {
       let pageItem = URLQueryItem(
            name: "page",
            value: page.toString())
        let limitItem = URLQueryItem(
            name: "limit",
            value: limit.toString())
        
        return Endpoint(path: "list",queryItems: [pageItem,limitItem])
    }
    static func normalPhoto(_ id: String, withWidth: String, height: String = "250", withtype type: String = "" ) -> String {
        var  finalURL = "id/" + id + "/" + withWidth + "/" + height
        if !type.isEmpty {
            finalURL = finalURL + "?" + type
        }
        return "https://picsum.photos/" + finalURL
    }
    static func photoDetail(_ id: String) -> Endpoint {
       
        return Endpoint(path: "id/" + id + "/info",version: "/")
    }
    
    
}
extension Int
{
    func toString() -> String
    {
        return String(self)
    }
}
