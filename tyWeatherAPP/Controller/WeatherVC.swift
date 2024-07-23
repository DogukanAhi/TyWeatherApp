import UIKit

class WeatherVC: UIViewController {
    var models = [WeatherModel]()
    var favoriteCityNames = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var isActive: Bool = false
    var refreshControl = UIRefreshControl()
    private lazy var listLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        customizeTabBar()
        collectionView.isUserInteractionEnabled = true
        loadFavorites()
        addSwipeGestureRecognizers()
        refreshControl.addTarget(self, action: #selector(refreshViewController), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        //  getFetchedWeathers()
        getDataAndFetchWeathersWithCityName()
    }
    
    @objc func refreshViewController(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
            self.getFetchedWeathers()
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func addSwipeGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        collectionView.addGestureRecognizer(swipeLeft)
    }
    
    func getFetchedWeathers() {
        let dispatchGroup = DispatchGroup() // MARK: DispatchGroup sayesinde bütün işlemler bittikten sonra completion handler çağırılıyor ve collectionView sadece 1 kere güncelleniyor.
        dispatchGroup.enter()
        fetchWeather(for: .ankara) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchWeather(for: .gaziantep) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchWeather(for: .istanbul) {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { // MARK: bütün işlemler bitti şimdi istenilen reload işlemi gerçekleştiriliyor.
            self.collectionView.reloadData()
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? WeatherCell else { return }
            showFavoriteButton(on: cell)
            let model: WeatherModel
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                model = models.filter { favoriteCityNames.contains($0.cityName) }[indexPath.row]
            default:
                model = models[indexPath.row]
            }
            let cityName = model.cityName
            if !favoriteCityNames.contains(cityName) {
                favoriteCityNames.append(cityName)
                saveFavorites()
            }
        }
    }
    
    private func showFavoriteButton(on cell: WeatherCell) {
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
        guard let cell = sender.superview?.superview as? WeatherCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        if let cell = sender.superview?.superview as? WeatherCell,
           let indexPath = collectionView.indexPath(for: cell) {
            let model = models[indexPath.row]
            let cityName = model.cityName
            if !favoriteCityNames.contains(cityName) {
                favoriteCityNames.append(cityName)
                saveFavorites()
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 0
        }) { _ in
            sender.removeFromSuperview()
        }
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func getDataAndFetchWeathersWithCityName() {
        getDataFromFirestore { cityNames in
            let dispatchGroup = DispatchGroup()
            
            for city in cityNames {
                dispatchGroup.enter()
                self.fetchWeatherWithCityName(for: city) {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchWeatherWithCityName(for cityName: String, completion: @escaping () -> Void) {
        fetchTemperatureWithCityName(city: cityName) { result in
            switch result {
            case .success(let tempC):
                let weatherModel = WeatherModel(cityName: cityName, tempCelcius: tempC, conditionImage: #imageLiteral(resourceName: "clean"))
                
                if !self.models.contains(where: { $0.cityName == weatherModel.cityName }) {
                    self.models.append(weatherModel)
                }
                print(tempC)
                completion()
            case .failure(let error):
                print("Error fetching temperature: \(error)")
                completion()
            }
        }
    }
    
    func fetchWeather(for city: City, completion: @escaping () -> Void) {
        fetchTemperature(city: city) { result in
            switch result {
            case .success(let tempC):
                // Create the weather model
                let weatherModel = WeatherModel(cityName: city.capetalizedRawValue, tempCelcius: tempC, conditionImage: #imageLiteral(resourceName: "clean"))
                
                // Check if the model already exists
                if !self.models.contains(where: { $0.cityName == weatherModel.cityName }) {
                    self.models.append(weatherModel)
                }
                print(tempC)
                completion()
            case .failure(let error):
                print("Error fetching temperature: \(error)")
                completion()
            }
        }
    }
    
    private func customizeTabBar() {
        guard let tabBar = tabBarController?.tabBar else { return }
        tabBar.tintColor = .red
    }
    
    @IBAction func segmentControllerChanged(_ sender: Any) {
        collectionView.reloadData()
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favoriteCityNames, forKey: "favorites")
    }
    
    func loadFavorites() {
        guard let savedFavorites = UserDefaults.standard.object(forKey: "favorites") as? [String] else { return }
        favoriteCityNames = savedFavorites
    }
    
    func favoriteTapped(for model: WeatherModel) {
        if let index = favoriteCityNames.firstIndex(of: model.cityName) {
            favoriteCityNames.remove(at: index)
        } else {
            favoriteCityNames.append(model.cityName)
        }
        saveFavorites()
        collectionView.reloadData()
    }
    
    func isFavorite(cityName: String) -> Bool {
        return favoriteCityNames.contains(cityName)
    }
}

extension WeatherVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return models.filter { favoriteCityNames.contains($0.cityName) }.count
        default:
            return models.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let currentModel: WeatherModel
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            currentModel = models.filter { favoriteCityNames.contains($0.cityName) }[indexPath.row]
        default:
            currentModel = models[indexPath.row]
        }
        
        cell.configure(with: currentModel, isFavorite: { [weak self] cityName in // MARK: callback
            return self?.favoriteCityNames.contains(cityName) ?? false
        }, onFavoriteButtonTapped: { [weak self] model in
            self?.handleFavoriteTapped(for: model)
        })
        
        return cell
    }
    
    private func handleFavoriteTapped(for model: WeatherModel) {
        if let index = favoriteCityNames.firstIndex(of: model.cityName) {
            favoriteCityNames.remove(at: index)
        } else {
            favoriteCityNames.append(model.cityName)
        }
        saveFavorites()
        collectionView.reloadData()
    }
}

