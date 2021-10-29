//
//  APIService.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import Foundation
import SystemConfiguration

enum APIError: String {
    case noNetwork = "No Network 📲"
    case noData = "No data 😞"
    case errorOccured = "Error occured 🙆🏻"
}

enum SortBy: CustomStringConvertible {
    case relevant
    case release_date_desc
    case release_date_asc
    case popularity_desc
    case popularity_asc
    case vote_average_desc
    case vote_average_asc
    
    var description: String {
        switch self {
            case .relevant: return "relevant"
            case .release_date_desc: return "primary_release_date.desc"
            case .release_date_asc: return "primary_release_date.asc"
            case .popularity_desc: return "popularity.desc"
            case .popularity_asc: return "popularity.asc"
            case .vote_average_desc: return "vote_average.desc"
            case .vote_average_asc: return "vote_average.asc"
        }
    }
}

protocol APIServiceProtocol {
    func fetchMovies(_ sortBy: SortBy, _ page: Int, complete: @escaping (_ result: [Movie]?, _ error: APIError? )->() )
    func fetchMovieDetails(_ movieID: String, complete: @escaping (_ result: Movie?, _ error: APIError? )->())
}

class APIService: APIServiceProtocol {
    // function will helps to fetch movie list
    func fetchMovies(_ sortBy: SortBy, _ page: Int, complete: @escaping (_ result: [Movie]?, _ error: APIError? )->() ) {
        // format url with query
        guard let url = self.urlString(sortBy, page) else {
            return complete([], nil)
        }
                
        // encode url string
        guard let encodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // set up URLRequest
        guard let urlRequest = URL(string: encodedURLString) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // make a request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for error
            guard error == nil else {
                if self.isNetworkAvailable() {
                    complete(nil, APIError.errorOccured)
                } else {
                    complete(nil, APIError.noNetwork)
                }
                return
            }
            
            // make sure we got data in the response
            guard let data = data else {
                complete(nil, APIError.noData)
                return
            }
            
            do {
                let parsedResponse = try JSONDecoder().decode(Response.self, from: data)
                complete(parsedResponse.results, nil)
            } catch {
                // decode error
                return complete(nil, APIError.errorOccured)
            }
        }
        task.resume()
    }
    
    // function will helps to fetch single movie details
    func fetchMovieDetails(_ movieID: String, complete: @escaping (Movie?, APIError?) -> ()) {
        // format url with query
        let url = "\(BaseURL)\(kAPI.Movie)/\(movieID)?api_key=\(Key)"
        
        // encode url string
        guard let encodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // set up URLRequest
        guard let urlRequest = URL(string: encodedURLString) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // make a request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for error
            guard error == nil else {
                if self.isNetworkAvailable() {
                    complete(nil, APIError.errorOccured)
                } else {
                    complete(nil, APIError.noNetwork)
                }
                return
            }
            
            // make sure we got data in the response
            guard let data = data else {
                complete(nil, APIError.noData)
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                complete(movie, nil)
            } catch {
                // decode error
                return complete(nil, APIError.errorOccured)
            }
        }
        task.resume()
    }
    
    // formatted url string 
    private func urlString(_ sortBy: SortBy?, _ page: Int) -> String? {
        if let sort = sortBy, sort != .relevant {
            return "\(BaseURL)\(kAPI.Discover)?api_key=\(Key)&sort_by=\(sort)&page=\(page)"
        } else {
            return "\(BaseURL)\(kAPI.Discover)?api_key=\(Key)&page=\(page)"
        }
    }
    
    
    // Network/Mobile data check function
    private func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

