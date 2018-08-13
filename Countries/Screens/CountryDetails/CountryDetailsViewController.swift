import UIKit
import MapKit

class CountryDetailsViewController: UIViewController {
    
    // MARK: - Configuration
    
    struct Configuration {
        let mapRegion: MKCoordinateRegion
        
        let nameText: String
        let regionText: String
        let populationText: String
        let areaText: String
        
        init(country: CountryWithFullDetails) {
            let distance = country.area.squareRoot() * 1300
            mapRegion = MKCoordinateRegionMakeWithDistance(country.coordinate, distance, distance)
            
            nameText = country.name
            regionText = "\(country.subregion), \(country.region)"
            populationText = "Population: \(country.population)"
            areaText = "\(country.area) sq km"
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    
    // MARK: - Update
    
    func update(with config: Configuration, animated: Bool) {
        mapView.setRegion(config.mapRegion, animated: animated)
        
        nameLabel.text = config.nameText
        regionLabel.text = config.regionText
        populationLabel.text = config.populationText
        areaLabel.text = config.areaText
    }
}

extension CountryDetailsViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "CountryDetails" }
}
