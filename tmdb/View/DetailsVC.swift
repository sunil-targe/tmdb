//
//  DetailsVC.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import UIKit
import SafariServices

class DetailsVC: BaseVC {

    // all IBOutlest
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var homepageButton: UIButton!
    
    // movie ID
    var movie_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Naive binding
    override func initViewModel() {
        super.initViewModel()
        
        // closure to reload tableview once data sucessfully fetched
        viewModel.reloadDetailsClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let movie = self?.viewModel.movie {
                    self?.configureDetails(movie)
                }
                self?.tableView.reloadData()
            }
        }
        
        // fetch initial data
        if let movieID = movie_id {
            viewModel.initFetchMovieDetails(movieID)
        }
    }
    
    // MARK:- Actions
    @objc override func refresh(_ sender: AnyObject) {
        if let movieID = movie_id {
            viewModel.initFetchMovieDetails(movieID)
        }
    }
    
    // Open booking link in Safari
    @IBAction private func bookMovieAction() {
        if let url = URL(string: "https://www.cathaycineplexes.com.sg/") {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    // Open homepage in Safari
    @IBAction private func homepageAction(_ sender: UIButton) {
        guard let homepage = sender.titleLabel?.text else {
            return
        }
        
        if let url = URL(string: homepage) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
}

extension DetailsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.movie != nil {
            return 1
        }
        return 0
    }
    
    private func configureDetails(_ movie: Movie) {
        // title, release date, overview
        self.titleLabel.text = "\(movie.original_title) \(movie.release_date.dateYear())"
        self.releaseDateLabel.text = movie.release_date
        self.overviewLabel.text = movie.overview
        
        // set production country
        if let countries = movie.production_countries, countries.count>0 {
            let country = countries[0]
            self.releaseDateLabel.text = "\(movie.release_date) (\(country.iso_3166_1.uppercased()))"
        }
        
        // set genre
        if let genres = movie.genres, genres.count>0 {
            var genreString: String = ""
            for genre in genres {
                if genreString.isEmpty {
                    genreString = genre.name
                } else {
                    genreString = "\(genreString), \(genre.name)"
                }
            }
            self.genresLabel.text = genreString
        }
        
        // set duration
        if let duration = movie.runtime {
            let interval = duration*60
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .brief
            let formattedString = formatter.string(from: TimeInterval(interval))!
            self.durationLabel.text = formattedString
        }
        
        // set homepage
        if let homepage = movie.homepage, !homepage.isEmpty {
            self.homepageLabel.isHidden = false
            self.homepageButton.titleLabel?.numberOfLines = 0
            self.homepageButton.setTitle(homepage, for: .normal)
        }
        
        // status
        if let status = movie.status {
            self.statusLabel.text = status
        }
        
        // set original language
        self.languageLabel.text = movie.original_language.uppercased()
        
        // set poster images
        if let posterPath = movie.poster_path {
            self.posterImg.kf.setImage(with: URL(string: "\(ImageURL)\(posterPath)"), placeholder: UIImage(systemName: "tmdb_logo"))
        } else if let backdropPath = movie.backdrop_path {
            self.posterImg.kf.setImage(with: URL(string: "\(ImageURL)\(backdropPath)"), placeholder: UIImage(systemName: "tmdb_logo"))
        } else {
            self.posterImg.image = UIImage(named: "tmdb_logo")
        }
    }
}
