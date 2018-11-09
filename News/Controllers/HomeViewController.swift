//
//  HomeViewController.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {

    let networkClient = APIClient.sharedInstance
    
    var articlesLoader = Loader(APIClient.Endpoints.TopHeadlines)
//    var articles : Set<Article> = []
    var articles : [ResponseArticle.Article] = []
//    var articlesViewModels : [ArticleViewModel] = []
    var sources : [ResponseSource.Source] = []
    var searchBar : UISearchBar?
    var searchWord: String = ""
    
    @IBOutlet weak var articlesTabelView: UITableView!
    
    @IBOutlet weak var sourcesCollectionView: UICollectionView!
    @IBOutlet weak var endpointSegmentedController: UISegmentedControl!
    
    lazy var  spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: articlesTabelView.bounds.width, height: CGFloat(44))
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesTabelView.estimatedRowHeight = 125
        articlesTabelView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
        loadSources()
        loadArticles()
       
    }
    
    func loadArticles(){
        articlesLoader.load(endpoint: .TopHeadlines, page: 1, source: "abc-news") { [weak self] (articles) in
            guard let strongSelf = self else { return }
            //            strongSelf.articles = Set<Article>(articles)
            strongSelf.articles = articles
            strongSelf.articlesTabelView.reloadData()
        }
        
//        networkClient.getArticles(withEndpoint: .TopHeadlines, page: 1,source: "abc-news" ) { [weak self] (articles) in
//            print("response here")
//            guard let strongSelf = self else { return }
////            strongSelf.articles = Set<Article>(articles)
//            strongSelf.articles = articles
//            strongSelf.articlesTabelView.reloadData()
//        }
        
    }

    func loadMoreArticles(){
        articlesLoader.next(endpoint: .TopHeadlines, source: "abc-news") { [weak self] (articles) in
            guard let strongSelf = self else { return }
            strongSelf.spinner.stopAnimating()
            strongSelf.articlesTabelView.tableFooterView?.isHidden = true
            strongSelf.articles += articles
            strongSelf.articlesTabelView.reloadData()
        }
        
    }
    
    func loadSources() {
        networkClient.getSources(withEndpoint: .Sources) { [weak self] (sources) in
            guard let strongSelf = self else { return }
            strongSelf.sources = sources
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = self.articles[indexPath.row].articleURL else { return }
//        guard let url = Array(articles)[indexPath.row].articleURL else {
//            return
//        }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count  //+ (articlesLoader.hasMore ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articlesTabelView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
//        cell.titleArticleLbl.text = self.articles[indexPath.row].title
//        cell.titleArticleLbl.text = Array(articles)[indexPath.row].title
        cell.article = self.articles[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex  && articlesLoader.hasMore {
            // print("this is the last cell")
           
            
            self.articlesTabelView.tableFooterView = spinner
            self.articlesTabelView.tableFooterView?.isHidden = false
            loadMoreArticles()
//            networkClient.getArticles(withEndpoint: APIClient.Endpoints.TopHeadlines) { [weak self] (articles) in
//                guard let strongSelf = self else { return }
//                strongSelf.spinner.stopAnimating()
//                strongSelf.articlesTabelView.tableFooterView?.isHidden = true
////                 strongSelf.articles.union(Array(Set<Article>(articles)))
////                articles.forEach({
////                    guard !strongSelf.articles.contains($0) else { return }
////                    strongSelf.articles.append($0)
////                })
//                strongSelf.articles += articles
//                strongSelf.articlesTabelView.reloadData()
//
//            }
//
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchBar == nil {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: articlesTabelView.frame.width, height: 44))
            searchBar?.text = self.searchWord
            searchBar?.delegate = self
            searchBar?.backgroundColor = UIColor.white
            searchBar?.searchBarStyle = .minimal
            //            searchBar?.showsCancelButton = true
        }
        return searchBar
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.count == 0 {
            searchWord = ""
            articles = []
            articlesTabelView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text ?? ""
        
        
        
        searchBar.resignFirstResponder()
    }
}
