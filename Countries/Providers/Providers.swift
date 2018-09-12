enum Providers {
    static var countriesDatasource: CountriesDatasource = {
        #if PROD
            return LocalMockCountriesDatasource()
        #elseif DEBUG
            return RESTCountriesRemoteDatasource()
        #elseif QA
            return QACountriesRemoteDatasource()
        #endif
    }()
}
