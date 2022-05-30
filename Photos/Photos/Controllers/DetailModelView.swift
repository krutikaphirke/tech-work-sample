
import Foundation
import UIKit
class DetailViewModel {
    private(set) var detail : Photo? {
        didSet {
            self.bindDetailMoviesModelToController()
        }
    }
    private(set) var errorMessage : String? {
        didSet {
            self.bindDetailMoviesModelToController()
        }
    }
    let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 250.0)
    var bindDetailMoviesModelToController : (() -> ()) = {}
    var imageLoaded:((Data?) -> ()) = {_ in }
    init(_ id: String) {
        self.getNormalPhoto(id) { sucess in
            if sucess {
                //set default fetch for image
                self.getProperImageFor(index: 0)
            }
         // if not success then show error 
        }
    }
    func getProperImageFor(index: Int) {
        var finalURL = ""
        guard let ID = detail?.id else { return  }
        switch (index) {
            case 0:
                // get normal image
                finalURL = Endpoint.normalPhoto(ID, ofType: .normal, size: imageSize)
            case 1:
                // get blur image
                finalURL = Endpoint.normalPhoto(ID, ofType: .blur(5.toString()), size: imageSize)
            case 2:
                // get grayScale Image
                finalURL = Endpoint.normalPhoto(ID, ofType: .gray, size: imageSize)
            default:
                finalURL = ""
        }
        self.getPhoto(finalURL) { [weak self] data in
            self?.imageLoaded(data)
        }
    }
    func getNormalPhoto(_ id: String, callback: @escaping (Bool) -> Void) {
        NetworkManager.shared.httpGet(url: Endpoint.photoDetail(id)) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Photo.self, from: data)
                    self.detail = res
                    callback(true)
                } catch {
                    //error decoding the data
                }
                if let error = error {
                        // show error message to user
                    self.errorMessage = error.message
                }
            
            }
            if data == nil && error == nil {
                    // show error message to user
                self.errorMessage = "Something went wrong! Please try again"
            }
            callback(false)
        }
    }
    
    // get image from url
    private func getPhoto(_ downloadURL : String, completion: @escaping (Data?) -> Void) {
        NetworkManager.shared.httpGet(url: downloadURL) { data, error in
                completion(data)
        }
    }
}
