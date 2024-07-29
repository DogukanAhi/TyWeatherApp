import UIKit

class WeatherVCMVVM: UIViewController {
    private var viewModel: WeatherViewModel!
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temperatureService = MockTemperatureService() // Dependency Injection
        viewModel = WeatherViewModel(temperatureService: temperatureService)
        
        segmentedControl.selectedSegmentIndex = 0
        collectionView.isUserInteractionEnabled = true
        viewModel.loadFavorites()
        addSwipeGestureRecognizers()
        refreshControl.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        viewModel.updateUI = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.getFetchedWeathers { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc func refreshViewController(send: UIRefreshControl) {
        viewModel.getFetchedWeathers { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    private func addSwipeGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        collectionView.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
           let cell = collectionView.cellForItem(at: indexPath) as? WeatherCellMVVM {
            cell.showFavoriteButton()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.collectionView.reloadData()
    }
}

extension WeatherVCMVVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredModels(for: segmentedControl.selectedSegmentIndex).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCellMVVM", for: indexPath) as! WeatherCellMVVM
        let currentModel = viewModel.filteredModels(for: segmentedControl.selectedSegmentIndex)[indexPath.row]
        cell.configure(with: currentModel, isFavorite: { [weak self] cityName in
            return self?.viewModel.isFavorite(cityName: cityName) ?? false
        }, onFavoriteButtonTapped: { [weak self] model in
            self?.viewModel.favoriteTapped(for: model)
        })
        return cell
    }
}
