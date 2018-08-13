import Foundation

class LocalMockCountriesDatasource: CountriesDatasource {
    
    // MARK: - Errors
    
    enum Error: Swift.Error {
        case failedToFindCountryWithName(String)
    }
    
    // MARK: - Fetching
    
    func fetchCountries(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<[CountryWithNameRegionAndSubregionOnly]>) -> Void)
    {
        resultQueue.asyncAfter(seconds: 0.5) {
            let countries = self.countries.map({ CountryWithNameRegionAndSubregionOnly($0) })
            resultHandler( .success(countries) )
        }
    }
    
    func fetchCountry(
        named name: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<CountryWithFullDetails>) -> Void)
    {
        resultQueue.asyncAfter(seconds: 0.5) {
            guard let matchingCountry = self.countries.first(where: { $0.name == name }) else {
                let error = Error.failedToFindCountryWithName(name)
                resultHandler( .failure(error) )
                return
            }
            
            resultHandler( .success(matchingCountry) )
        }
    }
    
    private let countries: [CountryWithFullDetails] = [
        CountryWithFullDetails(
            name: "Australia",
            region: "Oceania",
            subregion: "Australia and New Zealand",
            population: 24117360,
            latlng: [-27, 133],
            area: 7692024
        ),
        CountryWithFullDetails(
            name: "Canada",
            region: "Americas",
            subregion: "Northern America",
            population: 36155487,
            latlng: [60, -95],
            area: 9984670
        ),
        CountryWithFullDetails(
            name: "Germany",
            region: "Europe",
            subregion: "Western Europe",
            population: 81770900,
            latlng: [51, 9],
            area: 357114
        ),
    ]
}
