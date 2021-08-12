//
//  DetailViewController.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import UIKit
import Combine

extension WViewControllerFactory {
    func createDetailVC(service: HomeService, book: Book) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.model = DetailViewModel(service: service, book: book)
        return vc
    }
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageBack: UIImageView!
    
    var model: DetailViewModel!
    
    private var comments: [Comment] = []
    private var isLoading: Bool = false
    private var commentsPub: AnyCancellable?
    private var loadingPub: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SetUp TableView
        tableView.delegate = self
        tableView.dataSource = self
        model.getComments()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backAction(tapGestureRecognizer:)))
        imageBack.isUserInteractionEnabled = true
        imageBack.addGestureRecognizer(tapGestureRecognizer)
        
        commentsPub = model.$listComments.sink(receiveValue: { [weak self] resultComments in
            self?.comments = resultComments
            self?.tableView.reloadData()
        })
        
        loadingPub = model.$isLoading.sink(receiveValue: { [weak self] state in
            self?.showLoading(state)
        })
    }
    
    func showLoading(_ show:Bool){
        isLoading = show
        tableView.reloadData()
    }

    @objc func backAction(tapGestureRecognizer: UITapGestureRecognizer) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegate

extension DetailViewController: UITableViewDelegate{
    
}

// MARK: - TableView DataSource

extension DetailViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || isLoading{
            return 1
        }
        return comments.count
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
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader", for: indexPath) as! CellHeader
            cell.cardView.layer.cornerRadius = 10
            cell.cardView.clipsToBounds = true
            cell.titleBook.text = "\(model.book.title ?? "")"
            cell.authorBook.text = "\(model.book.author ?? "")"
            cell.genreBook.text = "\(model.book.genere ?? "")"
            cell.stateBook.text = "\(model.book.status ?? "")"
            cell.yearBook.text = "\(model.book.year ?? "")"
            let url = URL(string: model.book.image ?? "")
            cell.imageBook.kf.setImage(
                with: url,
                placeholder: UIImage(named: "default_image")
            )
            return cell
        }
        if indexPath.section == 1{
            let comment = comments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CellBook
            cell.cardView.layer.cornerRadius = 10
            cell.cardView.clipsToBounds = true
            cell.titleBook.text = "\(comment.user?.username ?? "")"
            cell.subTitleBook.text = "\(comment.content ?? "")"
            let url = URL(string: comment.user?.image ?? "")
            cell.imageBook.layer.cornerRadius = cell.imageBook.frame.size.width / 2
            cell.imageBook.clipsToBounds = true
            cell.imageBook.kf.setImage(
                with: url,
                placeholder: UIImage(named: "default_image")
            )
            return cell
        }
        return UITableViewCell()
    }
}
