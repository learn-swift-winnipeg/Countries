import UIKit

struct CountryCellConfiguration {
    let title: String
    let subtitle: String
    
    init(country: CountryWithNameRegionAndSubregionOnly) {
        self.title = country.name
        self.subtitle = "\(country.subregion), \(country.region)"
    }
}

extension UITableViewCell {
    func update(with countryCellConfig: CountryCellConfiguration) {
        self.textLabel?.text = countryCellConfig.title
        self.detailTextLabel?.text = countryCellConfig.subtitle
    }
}
