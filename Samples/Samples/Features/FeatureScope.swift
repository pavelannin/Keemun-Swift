import Foundation
import Keemun
import SwiftUI

class FeatureScope {
    
    func makeCounterConnector() -> CounterConnector { CounterConnector() }
    
    class CounterConnector {
        private let connector: KeemunConnector<CounterFeature.ViewState, CounterFeature.ExternalMsg>
        
        init() {
            self.connector = KeemunConnector(CounterFeature())
        }
        
        func makeView() -> CounterFeatureView {
            return .init(connector)
        }
    }
}
