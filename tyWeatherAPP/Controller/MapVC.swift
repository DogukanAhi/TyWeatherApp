import UIKit
import MapKit
var cityDegrees  = ["ankara":0.0,"istanbul":0.0,"gaziantep":0]
class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        self.fetchWeather(for: .ankara)
        self.fetchWeather(for: .gaziantep)
        self.fetchWeather(for: .istanbul)
    }
    func fetchWeather(for city: City) {
        fetchTemperature(city: city) { result in
            switch result {
            case .success(let tempC):
                print(city.rawValue)
                cityDegrees.updateValue(tempC, forKey: String(city.rawValue))
                DispatchQueue.main.async {
                    self.addAnnotation(cityName: String(city.rawValue))
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default)
                self.present(alert,animated: true)
                alert.addAction(okButton)
            }
        }
    }
    func addAnnotation(cityName: String) {
        let coordinateGaziantep = CLLocationCoordinate2D(latitude: 37.0667, longitude: 37.3833)
        let coordinateAnkara = CLLocationCoordinate2D(latitude: 39.9272, longitude: 32.8644)
        let coordinateIstanbul = CLLocationCoordinate2D(latitude: 41.0222, longitude: 28.976)
        let annotation = MKPointAnnotation()
        switch(cityName) {
        case "ankara":
            annotation.coordinate = coordinateAnkara
            annotation.title = "Ankara \(cityDegrees["ankara"]!)"
            self.mapView.addAnnotation(annotation)
        case "istanbul":
            annotation.coordinate = coordinateIstanbul
            annotation.title = "Istanbul \(cityDegrees["istanbul"]!)"
            self.mapView.addAnnotation(annotation)
        case "gaziantep":
            annotation.coordinate = coordinateGaziantep
            annotation.title = "Gaziantep \(cityDegrees["gaziantep"]!)"
            self.mapView.addAnnotation(annotation)
        default:
            break
        }
    }
}
