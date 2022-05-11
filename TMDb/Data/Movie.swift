//
//  Popular.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//

import Foundation

    // MARK: - Popular
struct Movie: Codable {
    let page: Int
    let results: [Result]
    let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

    // MARK: - Result
struct Result: Codable {
    let posterPath: String?
    let adult: Bool
    let overview, releaseDate: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    // get poster url by preadding server url to posterPath
    var posterURL: URL? {
        let fileURL = "https://image.tmdb.org/t/p/w500" + (self.posterPath ?? "")
        return URL(string: fileURL)
    }
    // get date string format
    var releaseDateString: String{
        let date = DateFormatterHelper.toDate(self.releaseDate)
        let shortDate = DateFormatterHelper.shortDateFormat(date)
        return shortDate
        
    }
}
