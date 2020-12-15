
import UIKit
import WebKit
class WebViewController: UIViewController {

    private let webView: WKWebView = {
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
//        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
        
    }()
    private let url: URL
     
    init(url: URL, title: String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
//        webView.backgroundColor = .systemBackground
        addButtons()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    private func addButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }
    
    @objc private func didTapBack(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapRefresh(){
    webView.load(URLRequest(url: url))
    }
    

}
