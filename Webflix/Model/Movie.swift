struct Movies: Codable {
    struct Movie: Codable {
        let title: String
        let year: String
        let poster: String
        let imdbID: String
    }
    var totalResults: String
    var searchedText: String
    var search: [Movie]
}
