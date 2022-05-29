
import Foundation
class DetailViewModel {
    private(set) var detail : PhotoDetail? {
        didSet {
            self.bindDetailMoviesModelToController()
        }
    }
    private(set) var errorMessage : String? {
        didSet {
            self.bindDetailMoviesModelToController()
        }
    }

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
        switch (index) {
            case 0:
                // get normal image
                finalURL = detail?.normalImagURL ?? ""
            case 1:
                // get blur image
                finalURL = detail?.blurImageURL ?? ""
            case 2:
                // get grayScale Image
                finalURL = detail?.grayscaleImageURL ?? ""
            default:
                finalURL = ""
        }
        self.getPhoto(finalURL) { [weak self] data in
            self?.imageLoaded(data)
        }
    }
    func getNormalPhoto(_ id: String, callback: @escaping (Bool) -> Void) {
        NetworkManager.shared.httpGet(url: Endpoint.photoDetail(id).url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(PhotoDetail.self, from: data)
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
        guard let url = URL(string: downloadURL) else { return}
        NetworkManager.shared.httpGet(url: url) { data, error in
                completion(data)
        }
    }
}
