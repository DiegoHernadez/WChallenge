//
//  HomeViewController.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import UIKit
import Combine
import Kingfisher

class WViewControllerFactory {
    func createHomeVC() -> UITabBarController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let rootVc = storyboard.instantiateViewController(withIdentifier: "rootHomeVC") as! UINavigationController
        let tabBar = rootVc.viewControllers.first as! UITabBarController
        let vc = tabBar.viewControllers?.first as! HomeViewController
        vc.model = HomeViewModel()
        return tabBar
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackNavBar: UIStackView!
    @IBOutlet weak var imageSearch: UIImageView!
    @IBOutlet weak var viewNavBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackSearchBar: UIStackView!
    @IBOutlet weak var constraintTopBar: NSLayoutConstraint!
    
    
    var model: HomeViewModel!
    
    private var isLoading: Bool = false
    private var listBooks: [Book] = []
    private var filteredData: [Book] = []
    private var loadingPub: AnyCancellable?
    private var booksPub: AnyCancellable?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        showNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SetUp tableView
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        model.getBooks()
        searchBar.showsCancelButton = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSearch(tapGestureRecognizer:)))
        imageSearch.isUserInteractionEnabled = true
        imageSearch.addGestureRecognizer(tapGestureRecognizer)
        
        booksPub = model.$listBooks.sink(receiveValue: { [weak self] books in
            self?.listBooks = books
            self?.filteredData = books
            self?.tableView.reloadData()
        })
        
        loadingPub = model.$isLoading.sink(receiveValue: { [weak self] state in
            self?.showLoading(state)
        })
    }
    
    func showNavBar(){
        searchBar.endEditing(true)
        searchBar.text = ""
        filteredData = listBooks
        constraintTopBar.constant = 0
        stackSearchBar.isHidden = true
        searchBar.isHidden = true
        UIView.animate(withDuration: 0.40, animations: { [weak self] in
            self?.viewNavBar.isHidden = false
            self?.stackNavBar.isHidden = false
        })
        tableView.reloadData()
    }
    
    func showLoading(_ show:Bool){
        isLoading = show
        tableView.reloadData()
    }
    
    @objc func onSearch(tapGestureRecognizer: UITapGestureRecognizer){
        constraintTopBar.constant = 40
        stackSearchBar.isHidden = false
        searchBar.isHidden = false
        UIView.animate(withDuration: 0.40, animations: { [weak self] in
            self?.viewNavBar.isHidden = true
            self?.stackNavBar.isHidden = true
        })
    }
}

// MARK: tableView Delegate

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcFactory = WViewControllerFactory()
        if !(filteredData.isEmpty) {
            searchBar.endEditing(true)
            let book = filteredData[indexPath.row]
            let vc = vcFactory.createDetailVC(service: model.service, book: book)
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: tableView Datasource

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.count == 0 || isLoading{
            return 1
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let reuseId = "loadingCellId"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            for subView in cell.contentView.subviews {
                if let actInd = subView as? UIActivityIndicatorView {
                    actInd.startAnimating()
                }
            }
            return cell
        }
        if filteredData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as! DefaultCell
            cell.defaultImage.image = UIImage(named: "Group")
            cell.labelTitle.text = "No se encontró algún libro"
            return cell
        }
        let book = filteredData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBook", for: indexPath) as! CellBook
        cell.cardView.layer.cornerRadius = 10
        cell.cardView.clipsToBounds = true
        cell.titleBook.text = "\(book.title ?? "")"
        cell.subTitleBook.text = "\(book.author ?? "")"
        let url = URL(string: book.image ?? "")
        cell.imageBook.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default_image")
        )
        return cell
    }
    
}

// MARK: - SearchBar config

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == ""{
            filteredData = listBooks
        }else{
            for book in listBooks{
                if let title = book.title{
                    if title.lowercased().contains(searchText.lowercased()){
                        filteredData.append(book)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showNavBar()
    }
    
}
