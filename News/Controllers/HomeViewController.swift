//
//  HomeViewController.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController, ArticleTableViewCellDelegate {
   
    

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    
    let networkClient = APIClient.sharedInstance
    
    var articlesLoader = Loader(APIClient.Endpoints.TopHeadlines)
//    var articles : Set<Article> = []
//    var articles : [ResponseArticle.Article] = []
    var articleViewModel : [ArticleViewModel] = []
//    var articlesViewModels : [ArticleViewModel] = []
    var sources : [ResponseSource.Source] = []
    var searchBar : UISearchBar?
    
    
    var sourceFilter : String = "abc-news"
    var endpointFilter : String = APIClient.Endpoints.Everything.description
    var searchWordFilter: String? = nil
    
    
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
        
        
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(loadArticles), for: .valueChanged)
        articlesTabelView.refreshControl = refreshController
        
        articlesTabelView.estimatedRowHeight = 125
        articlesTabelView.rowHeight = UITableView.automaticDimension
        navigationController?.title = "Latest News !"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        // Do any additional setup after loading the view.
      
     
       
        loadSources()
        loadArticles()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = self.articlesTabelView.indexPathForSelectedRow {
            self.articlesTabelView.deselectRow(at: selectedIndexPath, animated: false)
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: .none, queue: OperationQueue.main) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.articlesTabelView.reloadData()
           
            let selectedTabBarIndexPath = strongSelf.sourcesCollectionView.indexPathsForSelectedItems?.first
                
            
            strongSelf.sourcesCollectionView.reloadData()
            if let selectedTabBarIndexPath = selectedTabBarIndexPath  { strongSelf.sourcesCollectionView.selectItem(at: selectedTabBarIndexPath, animated: false, scrollPosition: .left) }
            
        }
      
    }
    @objc func loadArticles(){
        articlesTabelView.refreshControl?.beginRefreshing()
        articlesLoader.load(query: self.searchWordFilter,endpoint: self.endpointFilter, page: 1, source: self.sourceFilter) { [weak self] (articles) in
            guard let strongSelf = self else { return }
            //            strongSelf.articles = Set<Article>(articles)
            
//            strongSelf.articles = articles
            strongSelf.articleViewModel = articles.map({ (article)  in
                ArticleViewModel(article: article)
            })
            strongSelf.articlesTabelView.reloadData()
            strongSelf.articlesTabelView.refreshControl?.endRefreshing()
            if strongSelf.articlesLoader.hasMore {
                strongSelf.articlesTabelView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
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
        articlesLoader.next(query: self.searchWordFilter,endpoint: self.endpointFilter, source: self.sourceFilter) { [weak self] (articles) in
            guard let strongSelf = self else { return }
            strongSelf.spinner.stopAnimating()
            strongSelf.articlesTabelView.tableFooterView?.isHidden = true
//            strongSelf.articles += articles
            strongSelf.articleViewModel += articles.map({ (article)  in
                ArticleViewModel(article: article)
            })
            strongSelf.articlesTabelView.reloadData()
        }
        
    }
    
    func loadSources() {
        networkClient.getSources(withEndpoint: .Sources) { [weak self] (sources) in
            guard let strongSelf = self else { return }
            strongSelf.sources = sources
            strongSelf.sourcesCollectionView.reloadData()
//            if sources.count > 0 {
                strongSelf.sourcesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
//            }
        }
    }
    
   
    @IBAction func endpointsFilterClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.endpointFilter = APIClient.Endpoints.Everything.description
            loadArticles()
        case 1:
            self.endpointFilter = APIClient.Endpoints.TopHeadlines.description
            loadArticles()
        default:
            break
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
    @IBAction func leftBtnClicked(_ sender: Any) {
        let collectionViewWidth =  self.sourcesCollectionView.bounds.width
        let distanceToMove = self.sourcesCollectionView.contentOffset.x - collectionViewWidth
         self.moveScroll(withDistance: distanceToMove)
    }
    @IBAction func rightBtnClicked(_ sender: Any) {
        let collectionViewWidth =  self.sourcesCollectionView.bounds.width
        let distanceToMove = self.sourcesCollectionView.contentOffset.x + collectionViewWidth
        self.moveScroll(withDistance: distanceToMove)
    }
    func moveScroll(withDistance : CGFloat){
        let collectionViewFrame = CGRect(x: withDistance, y: self.sourcesCollectionView.contentOffset.y, width: self.sourcesCollectionView.frame.width, height: self.sourcesCollectionView.frame.height)
        self.sourcesCollectionView.scrollRectToVisible(collectionViewFrame, animated: true)
    }
    
    func readMoreBtnClicked(cell: ArticleTableViewCell) {
        let indexPathForReadMore = self.articlesTabelView.indexPath(for: cell)
        self.articleViewModel[(indexPathForReadMore?.row)!].isExpanded = !self.articleViewModel[(indexPathForReadMore?.row)!].isExpanded 
        articlesTabelView.reloadRows(at: [indexPathForReadMore!], with: .automatic)
    }
  
    
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let url = self.articles[indexPath.row].articleURL else { return }
////        guard let url = Array(articles)[indexPath.row].articleURL else {
////            return
////        }
        guard let url = self.articleViewModel[indexPath.row].imageURL else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.articles.count  //+ (articlesLoader.hasMore ? 1 : 0)
        return self.articleViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.articlesTabelView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
//        cell.titleArticleLbl.text = self.articles[indexPath.row].title
//        cell.titleArticleLbl.text = Array(articles)[indexPath.row].title
        
//        cell.article = self.articles[indexPath.row]
        
        let articleViewModel = self.articleViewModel[indexPath.row]
        articleViewModel.configure(view: cell)
        cell.delegate  = self
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
        
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: articlesTabelView.frame.width, height: 44))
            searchBar?.text = self.searchWordFilter
            searchBar?.delegate = self
            searchBar?.backgroundColor = UIColor.white
            searchBar?.searchBarStyle = .minimal
            searchBar?.showsCancelButton = true
        
        return searchBar
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.count == 0 {
            searchWordFilter = nil
            self.articleViewModel = []
            loadArticles()
            articlesTabelView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWordFilter = searchBar.text ?? nil
        
//        if searchWordFilter.length > 0 {
//
//        }
        loadArticles()
        articlesTabelView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar?.setShowsCancelButton(true, animated: true)
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar?.setShowsCancelButton(false, animated: true)
        return true
    }
}
extension HomeViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sources.count
    }
 
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            leftBtn.isHidden = false
        } else if (indexPath.row == self.sources.count - 1) {
            rightBtn.isHidden = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.sources.count - 1) {
            self.rightBtn.isHidden = true
        } else if (indexPath.row == 0) {
            self.leftBtn.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if (indexPath.row == 0 ) {
//            leftBtn.isHidden = true
//        } else if (indexPath.row == self.sources.count) {
//            rightBtn.isHidden = true
//        } else {
//            leftBtn.isHidden = false
//            rightBtn.isHidden = false
//        }
         let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCollectionViewCell", for: indexPath) as! TabBarCollectionViewCell
//        cell.tabBarTitleLbl.text = self.sources[indexPath.row].name
        cell.tabBarTitleLbl.attributedText = NSAttributedString(string: "\(self.sources[indexPath.row].name)", attributes: titleAttributes)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = sources[indexPath.row].name.width(withConstrainedHeight: 50, font: UIFont.preferredFont(forTextStyle: .headline))
        
        return CGSize(width: width + 10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sourceFilter = self.sources[indexPath.row].id
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        loadArticles()
//        self.articlesTabelView.reloadData()
    }
    
    
}
