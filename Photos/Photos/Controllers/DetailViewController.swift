
import UIKit

class DetailViewController: UIViewController {
   
    @IBOutlet weak var imageLoadinIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var moviewPoster: UIImageView!
    var detailViewModel:  DetailViewModel!
    
    init?(coder: NSCoder, id: String) {
        super.init(coder: coder)
        
        detailViewModel = DetailViewModel(id)
        callToViewModelForUIUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorLoading.startAnimating()
        self.loadImage()
        // Do any additional setup after loading the view.
    }
    private func loadImage() {
        self.imageLoadinIndicator.startAnimating()
        detailViewModel.imageLoaded = { data in
            DispatchQueue.main.async {[weak self] in
                var image: UIImage!
                if let data = data {
                    image = UIImage(data: data)
                    
                }else {
                        //There is error loading image
                    image = UIImage(systemName: "xmark.octagon.fill")
                }
                self?.imageLoadinIndicator.stopAnimating()
                self?.moviewPoster.image = image
            }
        }
    }

    @IBAction func selectImageSegmentControl(_ sender: UISegmentedControl) {
        self.imageLoadinIndicator.startAnimating()
        detailViewModel.getProperImageFor(index: sender.selectedSegmentIndex)
    }
        // call back once get data from api
    private func callToViewModelForUIUpdate(){
        self.detailViewModel.bindDetailMoviesModelToController = {[weak self] in
            
            DispatchQueue.main.async {
                self?.indicatorLoading.stopAnimating()
                self?.authorLabel.text = "Author - " + (self?.detailViewModel.detail?.author ?? "")
                if self?.detailViewModel.errorMessage != nil {
                        // show message to user using alert or toast
                }
            }
        }
    }
   
}
