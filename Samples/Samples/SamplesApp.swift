import SwiftUI

@main
struct SamplesApp: App {
    private let featuresScope = FeatureScope()
    
    var body: some Scene {
        WindowGroup {
            ContentView(connector: featuresScope.makeCounterConnector())
        }
    }
}
