//
//  MainVC.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import UIKit
import Kingfisher

class HomeVC: BaseVC {

    // sort by query parameter (default is relevant)
    private var sortBy: SortBy = .relevant {
        didSet {
            self.pageIndex = 1 // default page index for sort function must be 1
        }
    }
    
    // page index to fetch data as per incremental pages (default index is 1)
    private var pageIndex = 1 {
        didSet {
            // Load more function
            viewModel.initFetchMovies(self.sortBy, pageIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Naive binding
    override func initViewModel() {
        super.initViewModel()
        
        // closure to reload tableview once data sucessfully fetched
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // fetch initial data
        viewModel.initFetchMovies(self.sortBy, pageIndex)
    }
    
    // MARK:- Actions
    @objc override func refresh(_ sender: AnyObject) {
        self.pageIndex = 1 // pull to refresh with default 1st offset
    }
    
    // sorting action
    @IBAction private func sort(_ sender: AnyObject) {
        var style: UIAlertController.Style = .actionSheet
        if UIDevice.current.model == "iPad" {
            style = .alert
        }
        
        let alert = UIAlertController(title: nil, message: "Sort By", preferredStyle: style)
            
        var action = UIAlertAction(title: "Relevant", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .relevant
        })
        action.setValue(UIImage(systemName: "video.badge.checkmark"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Release Date Descending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .release_date_desc
        })
        action.setValue(UIImage(systemName: "calendar.badge.clock"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Release Date Ascending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .release_date_asc
        })
        action.setValue(UIImage(systemName: "calendar.badge.clock"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Popularity Descending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .popularity_desc
        })
        action.setValue(UIImage(systemName: "heart.fill"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Popularity Ascending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .popularity_asc
        })
        action.setValue(UIImage(systemName: "heart.fill"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Rating Descending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .vote_average_desc
        })
        action.setValue(UIImage(systemName: "star.fill"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
        
        action = UIAlertAction(title: "Rating Ascending", style: .default, handler: { (UIAlertAction)in
            self.sortBy = .vote_average_asc
        })
        action.setValue(UIImage(systemName: "star.fill"), forKey: "image")
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(action)
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))

        self.present(alert, animated: true)
    }
}

// tableview delegate and datasource
extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = viewModel.movies, movies.count>0 {
            return movies.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? MovieTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        // check if movie list has data
        guard let movies = viewModel.movies else {
            return cell
        }
        
        // configure cell data
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.original_title
        cell.releaseDateLabel.text = movie.release_date.readableDate()
        cell.popularityLabel.text = "Popularity \(movie.popularity)"
        if let posterPath = movie.poster_path {
            cell.posterImg.kf.setImage(with: URL(string: "\(ImageURL)\(posterPath)"), placeholder: UIImage(systemName: "tmdb_logo"))
        } else if let backdropPath = movie.backdrop_path {
            cell.posterImg.kf.setImage(with: URL(string: "\(ImageURL)\(backdropPath)"), placeholder: UIImage(systemName: "tmdb_logo"))
        } else {
            cell.posterImg.image = UIImage(named: "tmdb_logo")
        }

        // return configured cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if data exist
        guard let movies = viewModel.movies else {
            return
        }
                
        // initiate details view controller and push it
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        let movie = movies[indexPath.row]
        vc?.movie_id = String(movie.id) // pass movie id to get more details
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // handling pagination when scrollview reach to bottom
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let scrollHeight = scrollView.frame.size.height
        let endScrolling = offsetY + scrollHeight
        
        if endScrolling >= scrollView.contentSize.height {
            pageIndex = pageIndex + 1
        }
    }
}


// MARK:-
// MovieTableViewCell class implementation
class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
}
