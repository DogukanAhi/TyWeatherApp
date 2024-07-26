import UIKit

class WeatherVCMVVM: UIViewController {
    private var viewModel = WeatherViewModel()
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            showFavoriteButton(on: cell)
            let model: WeatherModelMVVM
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                model = viewModel.models.filter { viewModel.isFavorite(cityName: $0.cityName) }[indexPath.row]
            default:
                model = viewModel.models[indexPath.row]
            }
            let cityName = model.cityName
            if !viewModel.isFavorite(cityName: cityName) {
                viewModel.favoriteTapped(for: model)
            }
        }
    }
    
    private func showFavoriteButton(on cell: WeatherCellMVVM) {
        let favoriteButton = UIButton(frame: CGRect(x: cell.contentView.frame.width - 100, y: 0, width: 100, height: cell.contentView.frame.height))
        favoriteButton.setTitle("Favorite", for: .normal)
        favoriteButton.backgroundColor = .systemBlue
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        cell.contentView.addSubview(favoriteButton)
        favoriteButton.transform = CGAffineTransform(translationX: 100, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            favoriteButton.transform = .identity
        })
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? WeatherCellMVVM,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        let model = viewModel.models[indexPath.row]
        viewModel.favoriteTapped(for: model)
        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 0
        }) { _ in
            sender.removeFromSuperview()
        }
        self.collectionView.reloadItems(at: [indexPath])
    }
    

    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.collectionView.reloadData()
    }
}

extension WeatherVCMVVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return viewModel.models.filter { viewModel.isFavorite(cityName: $0.cityName) }.count
        default:
            return viewModel.models.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCellMVVM", for: indexPath) as! WeatherCellMVVM
        let currentModel: WeatherModelMVVM
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            currentModel = viewModel.models.filter { viewModel.isFavorite(cityName: $0.cityName) }[indexPath.row]
        default:
            currentModel = viewModel.models[indexPath.row]
        }
        cell.configure(with: currentModel, isFavorite: { [weak self] cityName in
            return self?.viewModel.isFavorite(cityName: cityName) ?? false
        }, onFavoriteButtonTapped: { [weak self] model in
            self?.viewModel.favoriteTapped(for: model)
        })
        return cell
    }
}
