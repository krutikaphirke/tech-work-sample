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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // by default popular movie get loaded
        self.movieViewModel = MoviesViewModel()
        self.configuretableView()
        self.title = "Movies"
        self.callbackForMovies()
        self.loadingIndicator.startAnimating()
        // set defualt tab
        self.segemetControl.selectedSegmentIndex = 0
       
    }
    func configuretableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    @IBAction func segementControlValueChanged(_ sender: UISegmentedControl) {
        
        movieViewModel.getMovieData(for: sender.selectedSegmentIndex) {[weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            }
        }
    }
    
    // call back once get data from api
    private func callbackForMovies(){
        
        self.movieViewModel.bindMoviesToController = {[weak self] in
            DispatchQueue.main.async { 
                self?.tableView.reloadData()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
   
    private func callbackForError() {
        self.movieViewModel.bindErrorToController = {
            DispatchQueue.main.async { [weak self] in
                
                self?.loadingIndicator.stopAnimating()
                if self?.movieViewModel.errorMessage != nil {
                        // show message to user using alert or toast
                }
            }
        }
        
    }

}

extension MoviesViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let result = movieViewModel.data[indexPath.row]
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
        
        let movie = movieViewModel.data[indexPath.row]
        if let destinationVc = self.getDetailVC(movie.id) {
            self.navigationController?.pushViewController(destinationVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
