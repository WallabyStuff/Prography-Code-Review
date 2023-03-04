//
//  ResponseObject.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

struct ResponseObject: Decodable {
  let status: String
  let data: MovieInfo

}

struct MovieInfo: Decodable {
  let movies: [MovieResponseDTO]
}
