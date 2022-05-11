//
//  ViewController.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var segemetControl: UISegmentedControl!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private var movieViewModel : MoviesViewModel!
    private var data: [Result] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // by default popular movie get loaded
        self.movieViewModel = MoviesViewModel()
        self.configuretableView()
        self.title = "Movies"
        self.callbackForPopularMovies()
        self.callbackForTopRatedMovies()
        self.loadingIndicator.startAnimating()
        // set defualt tab
        self.segemetControl.selectedSegmentIndex = 0
       
    }
    func configuretableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    @IBAction func segementControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // get popular movies
            data = self.movieViewModel.popularMovies?.results ?? []
        }else {
            // get top rated movies
            // check if toprated movie is already called from api if so then use existing data fetched from server
            if self.movieViewModel.topRatedMovies != nil {
                data = self.movieViewModel.topRatedMovies?.results ?? []
            }else {
                self.loadingIndicator.startAnimating()
                self.movieViewModel.getTopRatedMovies()
            }
            
        }
        self.tableView.reloadData()
    }
    
    // call back once get data from api
    private func callbackForPopularMovies(){
        
        self.movieViewModel.bindPopularMoviesToController = {
            DispatchQueue.main.async { [self] in
                data = self.movieViewModel.popularMovies?.results ?? []
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    private func callbackForTopRatedMovies() {
        self.movieViewModel.bindTopRatedToController = {
            DispatchQueue.main.async { [self] in
                data = self.movieViewModel.topRatedMovies?.results ?? []
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    private func callbackForError() {
        self.movieViewModel.bindErrorToController = {
            DispatchQueue.main.async { [self] in
                self.loadingIndicator.stopAnimating()
                if self.movieViewModel.errorMessage != nil {
                        // show message to user using alert or toast
                }
            }
        }
        
    }
}

extension MoviesViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let result = data[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = result.title
        config.secondaryText = result.releaseDateString
       
        movieViewModel.getMoviePoster(result.posterURL) { data in
            var image: UIImage!
            if let data = data {
                let img = UIImage(data: data)
                let targetSize = CGSize(width: 60, height: 30)
                
                let scaledImage = img?.scalePreservingAspectRatio(
                    targetSize: targetSize
                )
                image = scaledImage
            }else {
                //There is error loading image
                image = UIImage(systemName: "xmark.octagon.fill")
            }
            config.image = image
            cell.contentConfiguration = config
        }
        return cell
    }
}
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.data[indexPath.row]
        if let destinationVc = self.getDetailVC(movie.id) {
            self.navigationController?.pushViewController(destinationVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
