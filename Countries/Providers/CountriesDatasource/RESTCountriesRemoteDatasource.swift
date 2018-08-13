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
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard error == nil else { throw error! }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.failedWithError("Failed to access response as httpResponse")
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw Error.failedWithError("Non-200 http status code received: \(httpResponse.statusCode)")
                }
                guard let data = data else {
                    throw Error.failedWithError("Failed to access data in response.")
                }
                
                let countries = try JSONDecoder().decode([CountryWithNameRegionAndSubregionOnly].self, from: data)
                resultQueue.async { resultHandler( .success(countries) ) }
                
            } catch {
                resultQueue.async { resultHandler( .failure(error) ) }
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

extension URLSession {
    private enum Error: Swift.Error {
        case failedWithError(String)
    }
    
    func dataTask(
        with url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Data>) -> Void) -> URLSessionDataTask
    {
        return self.dataTask(with: url) { (data, response, error) in
            do {
                guard error == nil else { throw error! }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.failedWithError("Failed to access response as httpResponse")
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw Error.failedWithError("Non-200 http status code received: \(httpResponse.statusCode)")
                }
                guard let data = data else {
                    throw Error.failedWithError("Failed to access data in response.")
                }
                resultQueue.async { resultHandler( .success(data) ) }
                
            } catch {
                resultQueue.async { resultHandler( .failure(error) ) }
            }
        }
    }
}
