//
//  Movie.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/04.
//

import Foundation

// MARK: - MovieDataModel
struct MovieDataModel: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let movieCount, limit, pageNumber: Int
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movieCount = "movie_count"
        case limit
        case pageNumber = "page_number"
        case movies
    }
}

// MARK: - Movie
struct Movie: Codable {
    let id: Int
    let url: String
    let title: String
    let year: Int
    let rating: Double
    let runtime: Int
    let genres: [String]
    let summary, descriptionFull: String
    let language: String
    let backgroundImage, backgroundImageOriginal, smallCoverImage, mediumCoverImage: String
    let largeCoverImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case title
        case year, rating, runtime, genres, summary
        case descriptionFull = "description_full"
        case language
        case backgroundImage = "background_image"
        case backgroundImageOriginal = "background_image_original"
        case smallCoverImage = "small_cover_image"
        case mediumCoverImage = "medium_cover_image"
        case largeCoverImage = "large_cover_image"
    }
}
