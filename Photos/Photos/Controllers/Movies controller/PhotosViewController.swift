//
//  ViewController.swift
//  TMDb
//
//  Created by Krutika on 2022-05-29.
//

import UIKit
class PhotosViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var movieViewModel : PhotoViewModel!
    private var width = (UIScreen.main.bounds.width - 12 * 3) / 3
    override func viewDidLoad() {
        super.viewDidLoad()
        // by default popular movie get loaded
        self.movieViewModel = PhotoViewModel()
        self.configuretableView()
        self.title = "Photos"
        self.callbackForMovies()
        self.loadingIndicator.startAnimating()
    
    }
    //chek what haapens if remove it
    func configuretableView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
    }
    // call back once get data from api
    private func callbackForMovies(){
        
        self.movieViewModel.bindPhotosToController = {[weak self] in
            DispatchQueue.main.async { 
                self?.collectionView.reloadData()
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

extension PhotosViewController  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieViewModel.data.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = self.movieViewModel.data[indexPath.row]
        cell.loadImage(photo.normalImagURL(width: width))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.movieViewModel.data[indexPath.row]
        if let destinationVc = self.getDetailVC(photo.id) {
            self.navigationController?.pushViewController(destinationVc, animated: true)
        }
        
    }
    
}
