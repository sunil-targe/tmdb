//
//  ViewModel.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import Foundation

class ViewModel {
    let apiService: APIServiceProtocol

    // clousures
    var reloadTableViewClosure: (()->())?
    var reloadDetailsClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    // movie list
    var movies: [Movie]? {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // single movie with more details
    var movie: Movie? {
        didSet {
            self.reloadDetailsClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    
    // MARK:- Init api service
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // MARK:- fetch and manage data
    func initFetchMovies(_ sortBy: SortBy, _ page: Int) {
        self.isLoading = true
        apiService.fetchMovies(sortBy, page) { [weak self] (result, error) in
            self?.isLoading = false
            
            if let error = error {
                self?.alertMessage = error.rawValue
                return
            }
            
            guard let data = result else { return }
            
            if data.count > 0 {
                var tempData = [Movie]()
                
                // Adding previous data (on load more)
                if page > 1 {
                    if let previousData = self?.movies { tempData = previousData }
                }
                
                // Append current data
                for review in data {
                    tempData.append(review)
                }
                
                // set updated review list
                self?.movies = tempData
            } else {
                self?.movies = data
            }
        }
    }
    
    func initFetchMovieDetails(_ movieID: String) {
        self.isLoading = true
        apiService.fetchMovieDetails(movieID) { [weak self] (result, error) in
            self?.isLoading = false
            
            if let error = error {
                self?.alertMessage = error.rawValue
                return
            }
            guard let data = result else { return }
            self?.movie = data
        }
    }
}
