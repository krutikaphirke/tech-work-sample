//
//  DetailViewController.swift
//  TMDb
//
//  Created by Krutika on 2022-05-09.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviewPoster: UIImageView!
    var detailViewModel:  DetailViewModel!
    
    init?(coder: NSCoder, id: Int) {
        super.init(coder: coder)
        detailViewModel = DetailViewModel(id)
        callToViewModelForUIUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    // call back once get data from api
    private func callToViewModelForUIUpdate(){
        self.detailViewModel.bindDetailMoviesModelToController = {[weak self] in
            self?.loadImage()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.loadingIndicator.stopAnimating()
                if self?.detailViewModel.errorMessage != nil {
                        // show message to user using alert or toast
                }
            }
        }
    }
    // load image
    private func loadImage(){
        detailViewModel.getMoviePoster(detailViewModel.detail?.posterURL, completion: { [weak self] data in
            var image: UIImage!
            if let data = data {
               image = UIImage(data: data)
               
            }else {
                    //There is error loading image
                image = UIImage(systemName: "xmark.octagon.fill")
            }
            DispatchQueue.main.async {
                self?.moviewPoster.image = image
            }
        })
    }
    

}
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.textProperties.font = .systemFont(ofSize: 18)
        switch indexPath.row {
            case 0:
                config.text = detailViewModel.detail?.title
                config.textProperties.font = .boldSystemFont(ofSize: 18)
                
            case 1:
                config.text = "Released date: " + (detailViewModel.detail?.releaseDateString ?? "not available")
            case 2:
                let ratingLabel = "Rating: "
                if let voteAverage = detailViewModel.detail?.voteAverage  {
                    config.text = ratingLabel + "\(voteAverage)" + "/" +  "10"
                }else {
                    config.text = ratingLabel + "not available"
                }
           
            case 3:
                config.text = "Duration: " + (detailViewModel.detail?.duration ?? "--:--")
            case 4:
                config.text = "Genres: " + (detailViewModel.detail?.genresNames ?? "")
            case 5:
                config.text = detailViewModel.detail?.overview
                
            default:
                config.text = ""
        }
        cell.contentConfiguration = config
        return cell
    }

}

