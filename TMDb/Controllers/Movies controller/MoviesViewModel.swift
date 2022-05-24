//
//  GetPopularMovvies.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//
import Foundation

class MoviesViewModel {
    private var networkManger : NetworkManager!
    private var popularMovies : Movie?
    private var topRatedMovies : Movie?
    private(set) var errorMessage : String? {
        didSet {
            self.bindErrorToController()
        }
    }
    private(set) var data : [Result] = [] {
        didSet {
            self.bindMoviesToController()
        }
    }
    
    var bindMoviesToController : (() -> ()) = {}
    var bindTopRatedToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    init() {
        networkManger = NetworkManager()
        self.getPopularMovies()
    }
    func getMovieData(for type: Int = 0,callback: @escaping (_ isLoading: Bool) -> Void) {

        if type == 0 {
                // get popular movies
            data = self.popularMovies?.results ?? []
            callback(false)
        }else {
                // get top rated movies
                // check if toprated movie is already called from api if so then use existing data fetched from server
            if self.topRatedMovies != nil {
                data = self.topRatedMovies?.results ?? []
                callback(false)
            }else {
                self.getTopRatedMovies()
                callback(true)
                
            }
            
        }
    }
    // get popular movies from server
    func getPopularMovies() {
        networkManger.httpGet(url: Endpoint.popular.url) { data, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Movie.self, from: data)
                    self.popularMovies = res
                    self.data = self.popularMovies?.results ?? []
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
                    self.data = self.topRatedMovies?.results ?? []
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
