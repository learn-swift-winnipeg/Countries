import Foundation

class QACountriesRemoteDatasource: CountriesDatasource {
    
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
            name: "Country1",
            region: "Region1",
            subregion: "Subregion1",
            population: 0,
            latlng: [0, 0],
            area: 0
        )
    ]
}
