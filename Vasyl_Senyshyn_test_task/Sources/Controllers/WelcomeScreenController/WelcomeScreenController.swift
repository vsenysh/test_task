
import UIKit
import WebKit

class WelcomeScreen: UITableViewController, NetworkManagerDelegate, WKNavigationDelegate {
    
    var networkManager = NetworkManager()
    var posts = [Article]()

    private var paginatedPosts: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        
        
        networkManager.delegate = self
        networkManager.fetchNews("us")
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return paginatedPosts.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        
        
        guard indexPath.row != posts.count - 1 else { return }
        if indexPath.row == paginatedPosts.count - 1 {
            
            
            let startIndex = paginatedPosts.count
            let endIndex = startIndex + 9
            
            if endIndex <= posts.count {
                
                paginatedPosts.append(contentsOf: posts[startIndex...endIndex])
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as?  ArticleViewCell else{
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        
        
        let post = paginatedPosts[indexPath.row]
        cell.timePosted.text = post.publishedFormattedDateString
        cell.author.text = "by: \(post.author ?? "Author Unknown")"
        cell.title.text = post.articleDescription
        
        
        if let image = post.urlToImage {
            cell.imageForArticle.load(url: image)
        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = paginatedPosts[indexPath.row].url else{
            fatalError()
        }
        let webVC = WebViewController(url: url, title: paginatedPosts[indexPath.row].title)
        let navVC = UINavigationController(rootViewController: webVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func didUpdateNews(root: Root) {
        posts = root.articles
        
        paginatedPosts = posts.count >= 10 ? Array(posts[0...9]) : posts
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
    }
}


