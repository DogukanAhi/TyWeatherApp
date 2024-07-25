import UIKit

class CityWeatherCell: UICollectionViewCell {
    
    static let identifier = "CityWeatherCell"
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherImageView.heightAnchor.constraint(equalToConstant: 40),
            cityLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cityWeather: CityWeather) {
        cityLabel.text = cityWeather.cityName
        temperatureLabel.text = "\(cityWeather.temperature)°C"
        weatherImageView.image = UIImage(named: "clean")
    }
}
