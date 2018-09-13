import Foundation

class DEVCountriesRemoteDatasource: CountriesDatasource {
    
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
            name: "Reunion",
            region: "Africa",
            subregion: "Eastern Africa",
            population: 840974,
            latlng: [-21.15, 55.5],
            area: 0
        ),
        CountryWithFullDetails(
            name: "France",
            region: "Europe",
            subregion: "Western Europe",
            population: 66186000,
            latlng: [46, 2],
            area: 640679
        ),
        CountryWithFullDetails(
            name: "China",
            region: "Asia",
            subregion: "Eastern Asia",
            population: 1371590000,
            latlng: [35, 105],
            area: 9640011
        ),
    ]
}
