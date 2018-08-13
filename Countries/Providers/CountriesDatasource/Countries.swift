import CoreLocation

struct CountryWithNameRegionAndSubregionOnly: Codable {
    let name: String
    let region: String
    let subregion: String
}

extension CountryWithNameRegionAndSubregionOnly {
    init(_ countryWithFullDetails: CountryWithFullDetails) {
        self.name = countryWithFullDetails.name
        self.region = countryWithFullDetails.region
        self.subregion = countryWithFullDetails.subregion
    }
}

struct CountryWithFullDetails: Codable {
    let name: String
    let region: String
    let subregion: String
    let population: Int
    let latlng: [Double]
    let area: Double
    
    var coordinate: CLLocationCoordinate2D {
        // This implementation is out of pure laziness and should never, ever, be done this way.
        return CLLocationCoordinate2D(
            latitude: latlng[0],
            longitude: latlng[1]
        )
    }
}

