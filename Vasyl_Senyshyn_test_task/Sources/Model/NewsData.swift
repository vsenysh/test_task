import Foundation

struct Root: Codable {
    let status: String
    let totalResults: Int
    var articles: [Article]
}
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url, urlToImage: URL?
    let publishedAt: Date
    let content: String?
    
    
    var publishedFormattedDateString: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, articleDescription = "description", url, urlToImage, publishedAt, content
    }
}
struct Source: Codable {
    let id: String?
    let name: String
}
