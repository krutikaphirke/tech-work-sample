//
//  MovieDetail.swift
//  TMDb
//
//  Created by Krutika on 2022-05-09.
//

import Foundation
struct MovieDetail: Codable {
    let adult: Bool
    let backdropPath: String
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    // create the link to get image from server by preadding server url to backdropPath
    var posterURL: URL? {
        let fileURL = "https://image.tmdb.org/t/p/w500" + (self.backdropPath )
        return URL(string: fileURL)
    }
    // get list of genere in string fromat by sepertor
    var genresNames: String{
        let names = self.genres.map({$0.name})
        return names.joined(separator: ", ")
        
    }
    // get user friendly duration from minutes
    var duration:String {
        // (h,m)
        let hours = self.runtime / 60
        let minutes = self.runtime % 60
        let finalDuration = String(format: "%02d:%02d", hours, minutes)
        return finalDuration
    }
    // get formated date string
    var releaseDateString: String{
        let date = DateFormatterHelper.toDate(self.releaseDate)
        let shortDate = DateFormatterHelper.shortDateFormat(date)
        return shortDate
        
    }
}

    // MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

    // MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

    // MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1:Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1
        case name
    }
}

    // MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let iso639_1: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso639_1
        case name
    }
}
