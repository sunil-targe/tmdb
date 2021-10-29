//
//  Model.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import Foundation

// response model
struct Response: Codable {
    var page: Int
    var results: [Movie]
    var total_pages: Int
    var total_results: Int
}

// movie model
struct Movie: Codable {
    let title: String
    let original_title: String
    let id: Int
    let overview: String
    let release_date: String
    let original_language: String
    let popularity: Double
    let vote_count: Double
    let vote_average: Double
    // optional
    let poster_path: String?
    let backdrop_path: String?
    let genres: [Genre]?
    let runtime: Double?
    let tagline: String?
    let homepage: String?
    let status: String?
    let production_countries: [Country]?
}


// genre model
struct Genre: Codable {
    let id: Int
    let name: String
}

// production country model
struct Country: Codable {
    let iso_3166_1: String
    let name: String
}


