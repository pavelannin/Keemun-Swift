import SwiftUI

struct ContentView: View {
    let connector: FeatureScope.CounterConnector
    
    var body: some View {
        connector.makeView()
    }
}
