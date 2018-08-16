import XCTest

class CountriesUITests: XCTestCase {
    
    // MARK: - Stored Properties

    private var app: XCUIApplication!

    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = [
            "--countries-datasource", "local-mock",
        ]
        app.launch()
    }
    
    // MARK: - Tests

    func testCountryDetailsDisplayedOnTap() {
        // Add a screenshot of the Countries screen to the test report.
        attachScreenshot(withName: "Countries")
        
        // Select the Canada row.
        app.tables.staticTexts["Canada"].tap()
        
        // Wait for details screen to be presented.
        guard app.staticTexts.matching(identifier: "countryName").firstMatch.waitForExistence(timeout: 5.0)
            else { return XCTFail() }
        
        // Add a screenshot of the CountryDetails screen to the test report.
        attachScreenshot(withName: "CountryDetails")
        
        // Get the text label values to compare to our expected results.
        let name = app.staticTexts.matching(identifier: "countryName").firstMatch.label
        let region = app.staticTexts.matching(identifier: "countryRegion").firstMatch.label
        let population = app.staticTexts.matching(identifier: "countryPopulation").firstMatch.label
        let area = app.staticTexts.matching(identifier: "countryArea").firstMatch.label
        
        // Assert the actual values match our expectations.
        XCTAssertEqual(name, "Canada")
        XCTAssertEqual(region, "Northern America, Americas")
        XCTAssertEqual(population, "36155487 people")
        XCTAssertEqual(area, "9984670.0 sq km")
    }

    // MARK: - Attachments

    private func attachScreenshot(withName name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = name
        add(attachment)
    }
}
