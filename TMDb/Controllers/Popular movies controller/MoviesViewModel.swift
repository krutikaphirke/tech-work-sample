//
//  GetPopularMovvies.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//
import Foundation

class MoviesViewModel {
    private var networkManger : NetworkManager!
    private(set) var popularMovies : Movie? {
        didSet {
            self.bindPopularMoviesToController()
        }
    }
    private(set) var topRatedMovies : Movie? {
            didSet {
                self.bindTopRatedToController()
            }
        }
    private(set) var errorMessage : String? {
        didSet {
            self.bindErrorToController()
        }
    }
    var bindPopularMoviesToController : (() -> ()) = {}
    var bindTopRatedToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    init() {
        networkManger = NetworkManager()
        self.getPopularMovies()
    }
    // get popular movies from server
    func getPopularMovies() {
        networkManger.httpGet(url: Endpoint.popular.url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Movie.self, from: data)
                    self.popularMovies = res
                } catch {
                    // error while decoding the data
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
        // get top rated movies from server
    func getTopRatedMovies() {
        networkManger.httpGet(url: Endpoint.topRated.url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Movie.self, from: data)
                    self.topRatedMovies = res
                } catch {
                        // error while decoding the data
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
    // get poster image from url
    func getMoviePoster(_ url : URL?, completion: @escaping (Data?) -> Void) {
        if let url = url {
            networkManger.httpGet(url: url) { data, error in
                DispatchQueue.main.async {
                        completion(data)
                }
            }
        }
    }
}
