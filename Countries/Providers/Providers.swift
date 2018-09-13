enum Providers {
    static var countriesDatasource: CountriesDatasource = {
        #if PROD
            return RESTCountriesRemoteDatasource()
        #elseif DEV
            return DEVCountriesRemoteDatasource()
        #elseif QA
            return QACountriesRemoteDatasource()
        #elseif UIT
            return LocalMockCountriesDatasource()
        #elseif DEBUG
            return RESTCountriesRemoteDatasource()
        #endif
    }()
}
