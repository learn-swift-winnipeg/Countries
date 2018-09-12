// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	func customLane() {
        desc("Description of what the lane does")
		// add actions here: https://docs.fastlane.tools/actions
	}
    
    func qaLane() {
        desc("Quality Assurance Environment - to ship for testers")
        scan(scheme: "Countries Quality Assurance")
    }
    
    func productionLane() {
        desc("Production Environment - for the Apple Store")
        buildIosApp(scheme: "Countries")
    }
}
