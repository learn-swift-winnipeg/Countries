import UIKit

class CountriesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Stored Properties
    
    private var countries: [CountryWithNameRegionAndSubregionOnly] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchCountriesAndUpdateUI()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Fetching
    
    private func fetchCountriesAndUpdateUI() {
        Providers.countriesDatasource.fetchCountries(resultQueue: .main) { result in
            switch result {
            case .failure(let error):
                self.present(error: error)
                
            case .success(let countries):
                self.countries = countries
                self.updateUI()
            }
        }
    }
    
    // MARK: - Presentation
    
    private func present(error: Error) {
        let alertController = UIAlertController(
            title: "Oops! We've hit a snag.",
            message: "\(error)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction( title: "OK", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
    
    private func presentDetails(for country: CountryWithNameRegionAndSubregionOnly) {
        Providers.countriesDatasource.fetchCountry(named: country.name, resultQueue: .main) { result in
            switch result {
            case .failure(let error):
                self.present(error: error)
                
            case .success(let country):
                let countryDetailsViewController = CountryDetailsViewController.loadFromStoryboard()
                
                let config = CountryDetailsViewController.Configuration(country: country)
                countryDetailsViewController.update(with: config, animated: false)
                
                self.navigationController?.pushViewController(countryDetailsViewController, animated: true)
            }
        }
    }
    
    // MARK: - Update
    
    private func updateUI() {
        tableView.reloadData()
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        let country = countries[indexPath.row]
        let countryCellConfig = CountryCellConfiguration(country: country)
        cell.update(with: countryCellConfig)
        
        return cell
    }
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        presentDetails(for: country)
    }
}
