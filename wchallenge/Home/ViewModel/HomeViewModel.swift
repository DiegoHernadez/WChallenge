//
//  HomeViewModel.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var listBooks: [Book] = []
    
    var service: HomeService
    
    private var requestBooksPub: AnyCancellable?
    
    init() {
        service = HomeApiService()
    }
    
    func getBooks(){
        isLoading = true
        requestBooksPub = service.requestBooks()
            .sink { [weak self] (tmp) in
                self?.isLoading = false
                switch tmp {
                case .failure(let err):
                    print("Error getting books: \(err)")
                case .finished:
                    print("Finished getting books")
                }
            } receiveValue: { [weak self] (restultBooks) in
                self?.listBooks = restultBooks
            }
    }
}
