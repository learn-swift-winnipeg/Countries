enum Providers {
    static var countriesDatasource: CountriesDatasource = {
        guard
            let countriesDatasourceOption = CommandLine.option(for: "--countries-datasource"),
            let countriesDatasourceName = countriesDatasourceOption.valueArgument
            else { return RESTCountriesRemoteDatasource() }
        
        switch countriesDatasourceName {
        case "local-mock":
            return LocalMockCountriesDatasource()
            
        default:
            fatalError("Unknown countries datasource requested: \(countriesDatasourceName)")
        }
    }()
}
