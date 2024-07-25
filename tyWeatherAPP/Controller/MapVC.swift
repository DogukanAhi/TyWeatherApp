import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var cityDegrees  = ["ankara":0.0,"istanbul":0.0,"gaziantep":0]
    var cityNames: [String] = ["ankara", "istanbul", "gaziantep"]
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var favoriteCities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated(_:)), name: NSNotification.Name("favorites"), object: nil)
        loadInitialData()
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
    }
    
    private func loadInitialData() {
        
        if let savedFavorites = UserDefaults.standard.object(forKey: "favorites") as? [String] {
            favoriteCities = savedFavorites
        }
        
        
        for cityName in cityNames {
            fetchWeather(for: City(rawValue: cityName)!)
        }
    }
    
    @objc func favoritesUpdated(_ notification: Notification) {
        if let favorites = notification.userInfo?["favorites"] as? [String] {
            favoriteCities = favorites
            print("Updated favoriteCities:", favoriteCities)
            updateAnnotations()
        }
    }
    
    func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for cityName in cityNames {
            fetchWeather(for: City(rawValue: cityName)!)
        }
    }
    
    func fetchWeather(for city: City) {
        fetchTemperature(city: city) { result in
            switch result {
            case .success(let tempC):
                self.cityDegrees.updateValue(tempC, forKey: String(city.rawValue))
                DispatchQueue.main.async {
                    self.addAnnotation(cityName: String(city.rawValue))
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default)
                self.present(alert, animated: true)
                alert.addAction(okButton)
            }
        }
    }
    
    func addAnnotation(cityName: String) {
        let coordinates = [
            "ankara": CLLocationCoordinate2D(latitude: 39.9272, longitude: 32.8644),
            "istanbul": CLLocationCoordinate2D(latitude: 41.0222, longitude: 28.976),
            "gaziantep": CLLocationCoordinate2D(latitude: 37.0667, longitude: 37.3833)
        ]
        guard let coordinate = coordinates[cityName] else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(cityName.capitalized) \(cityDegrees[cityName]!)°C"
        
        
        let isFavorite = favoriteCities.contains(cityName)
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = true
        annotationView.pinTintColor = .clear // Hide default pin color
        annotationView.image = UIImage(systemName: isFavorite ? "star.fill" : "pin")
        
        self.mapView.addAnnotation(annotationView.annotation!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = pointAnnotation
            }
            if let title = pointAnnotation.title {
                let isFavorite = favoriteCities.contains(where: { title.contains($0) })
                annotationView?.pinTintColor = .clear 
                
                annotationView?.image = UIImage(systemName: isFavorite ? "star.fill" : "pin")
            }
            return annotationView
        }
        return nil
    }
}
