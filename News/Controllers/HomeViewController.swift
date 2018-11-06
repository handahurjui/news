//
//  HomeViewController.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let networkClient = APIClient.sharedInstance
    
    var articles : [Article] = []
//    var articlesViewModels : [ArticleViewModel] = []
    
    @IBOutlet weak var articlesTabelView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesTabelView.estimatedRowHeight = 125
        articlesTabelView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
        loadArticles()
    }
    
    func loadArticles(){
        
        networkClient.getArticles { [weak self] (articles) in
            print("response here")
            guard let strongSelf = self else { return }
            strongSelf.articles = articles
            strongSelf.articlesTabelView.reloadData()
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
        
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articlesTabelView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        cell.titleArticleLbl.text = self.articles[indexPath.row].title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
 
