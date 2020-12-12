
import UIKit

struct MovieResponse: Codable {

    var results: [MovieResponseItem]
    var dates: Dates
    var totalPages: Int
    var totalResults: Int
}
