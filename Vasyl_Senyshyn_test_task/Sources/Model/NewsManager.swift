import Foundation
protocol NetworkManagerDelegate{
    func didUpdateNews(root: Root)
}
struct NetworkManager{
    var delegate: NetworkManagerDelegate?
    
    
    
    func fetchNews(_ countryCode: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        urlComponents.queryItems = [.init(name: "apiKey", value: "a16b15f863454928804e218705d0f019"),
                                    .init(name:"country", value: countryCode)]
        
        if let url = urlComponents.url {
            performRequest(url)
        }
    }
    
    func performRequest(_ url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil{
                return
                
            }
            
            if let safedata = data {
                if let root = parseJson(data: safedata){
                    delegate?.didUpdateNews(root: root)
                }
            }
            
        }.resume()
        
        
        func parseJson(data: Data) -> Root?{
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                var root = try decoder.decode(Root.self, from: data)
                
                root.articles.sort(by: { $0.publishedAt > $1.publishedAt })
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                for index in 0..<root.articles.count {
                    root.articles[index].publishedFormattedDateString = dateFormatter.string(from: root.articles[index].publishedAt)
                }
                
                
                return root
                
            }catch{
                print(error)
                return nil
            }
            
        }
    }
    
}
