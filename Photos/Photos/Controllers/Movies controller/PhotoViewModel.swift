//
//  GetPopularMovvies.swift
//  TMDb
//
//  Created by Krutika on 2022-05-29.
//
import Foundation

class PhotoViewModel {
    private(set) var errorMessage : String? {
        didSet {
            self.bindErrorToController()
        }
    }
    private(set) var data : [Photo] = [] {
        didSet {
            self.bindPhotosToController()
        }
    }
    private var pageNumber = 0
    private var limit = 20
    var bindPhotosToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    init() {
        self.getPhotos()
    }
    
    // get popular movies from server
    func getPhotos() {
        NetworkManager.shared.httpGet(url: Endpoint.photoList(pageNumber, limit: limit).url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode([Photo].self, from: data)
                    self.data = res
                } catch {
                    // error while decoding the data
                    self.errorMessage = "error decoding the data"
                }
            }
            
            if let error = error {
                // show error message to user
                self.errorMessage = error.message
            }
            if data == nil && error == nil {
                    // show error message to user
                self.errorMessage = "Something went wrong! Please try again"
            }
        }
        
    }
}
