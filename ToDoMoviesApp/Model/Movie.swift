

import UIKit

struct MoviesResults: Codable {
    var page: Int
    var results: [Movie]
}

struct Movie: Codable {
    var overview: String
    var release: String
    var genres: [Int]
    var title: String
    var grade: Double
    var poster: String?
    
     
    enum CodingKeys: String, CodingKey {
        case release = "release_date"
        case genres = "genre_ids"
        case grade = "vote_average"
        case poster = "poster_path"
        case overview, title
    }
        
    func getGenresArray(genreIds: [Int]) -> String {
        var genreStringArray: [String] = []
        for genre in genreIds {
            switch genre {
            case 28: genreStringArray.append("Action")
            case 16: genreStringArray.append("Animation")
            case 99: genreStringArray.append("Documentary")
            case 18: genreStringArray.append("Drama")
            case 10751: genreStringArray.append("Family")
            case 14: genreStringArray.append("Fantasy")
            case 36: genreStringArray.append("History")
            case 35: genreStringArray.append("Comedy")
            case 10752: genreStringArray.append("War")
            case 80: genreStringArray.append("Crime")
            case 10402: genreStringArray.append("Music")
            case 9648: genreStringArray.append("Mystery")
            case 10749: genreStringArray.append("Romance")
            case 878: genreStringArray.append("Fiction")
            case 27: genreStringArray.append("Horror")
            case 707780: genreStringArray.append("Tv Movie")
            case 53: genreStringArray.append("Thriller")
            case 37: genreStringArray.append("Western")
            case 12: genreStringArray.append("Adventure")
            default: genreStringArray.append("Others")
            }
        }
        return genreStringArray.joined(separator: ", ")
    }
}
