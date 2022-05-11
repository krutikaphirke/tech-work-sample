//
//  DetailModelView.swift
//  TMDb
//
//  Created by Krutika on 2022-05-09.
//

import Foundation
class DetailViewModel {
    private var networkManger : NetworkManager!
    private(set) var detail : MovieDetail? {
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
    init(_ id: Int) {
        networkManger = NetworkManager()
        self.getMovieDetail(id)
    }
    // get movie detail
    func getMovieDetail(_ id: Int) {
        networkManger.httpGet(url: Endpoint.detailMovie(id).url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(MovieDetail.self, from: data)
                    self.detail = res
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
        }
    }
    // get poster image from url
    func getMoviePoster(_ url : URL?, completion: @escaping (Data?) -> Void) {
        if let url = url {
            networkManger.httpGet(url: url) { data, error in
                completion(data)
            }
        }
    }
}
