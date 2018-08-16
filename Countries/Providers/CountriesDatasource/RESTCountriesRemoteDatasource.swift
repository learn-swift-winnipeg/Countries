import Foundation

class RESTCountriesRemoteDatasource: CountriesDatasource {
    
    // MARK: - Errors
    
    enum Error: Swift.Error {
        case failedWithError(String)
        case failedToFindCountryWithName(String)
    }
    
    // MARK: - Fetching
    
    func fetchCountries(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<[CountryWithNameRegionAndSubregionOnly]>) -> Void)
    {
        let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;region;subregion")!
        
        URLSession.shared.dataTask(with: url, resultQueue: .main) { result in
            switch result {
            case .failure(let error):
                resultQueue.async { resultHandler( .failure(error) ) }
                
            case .success(let data):
                do {
                    let countries = try JSONDecoder().decode([CountryWithNameRegionAndSubregionOnly].self, from: data)
                    resultQueue.async { resultHandler( .success(countries) ) }
                } catch {
                    resultQueue.async { resultHandler( .failure(error) ) }
                }
            }
        }.resume()
    }
    
    func fetchCountry(
        named name: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<CountryWithFullDetails>) -> Void)
    {
        guard let percentEncodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            let error = Error.failedWithError("Failed to percent encode name: \(name)")
            resultQueue.async { resultHandler( .failure(error) ) }
            return
        }
        
        let url = URL(string: "https://restcountries.eu/rest/v2/name/\(percentEncodedName)?fields=name;region;subregion;population;latlng;area")!
        
        URLSession.shared.dataTask(with: url, resultQueue: .main) { result in
            switch result {
            case .failure(let error):
                resultQueue.async { resultHandler( .failure(error) ) }
                
            case .success(let data):
                do {
                    let countries = try JSONDecoder().decode([CountryWithFullDetails].self, from: data)
                    guard let matchingCountry = countries.first else {
                        throw Error.failedToFindCountryWithName(name)
                    }
                    resultQueue.async { resultHandler( .success(matchingCountry) ) }
                } catch {
                    resultQueue.async { resultHandler( .failure(error) ) }
                }
            }
        }.resume()
    }
}
