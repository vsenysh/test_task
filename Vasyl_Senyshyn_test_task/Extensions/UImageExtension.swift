import UIKit

extension UIImageView {
    func load(url: URL) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data) else {
                    
                    
                    
                    return
                }
                self.image = image
            }
        }.resume()
    }
}
