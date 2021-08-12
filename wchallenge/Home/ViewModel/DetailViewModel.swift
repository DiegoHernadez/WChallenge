//
//  DetailViewModel.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var listComments: [Comment] = []
    
    var service: HomeService
    var book: Book
    
    private var requestCommentsPub: AnyCancellable?
    
    init(service: HomeService, book: Book) {
        self.service = service
        self.book = book
    }
    
    func getComments(){
        isLoading = true
        requestCommentsPub = service.requestComments(bookId: book.id)
            .sink { [weak self] (tmp) in
                self?.isLoading = false
                switch tmp {
                case .failure(let err):
                    print("Error getting comments: \(err)")
                case .finished:
                    print("Finished getting comments")
                }
            } receiveValue: { [weak self] (restultComments) in
                self?.listComments = restultComments
            }
    }
}
