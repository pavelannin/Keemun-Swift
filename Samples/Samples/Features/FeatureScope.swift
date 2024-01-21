import Foundation
import KeemunSwift
import SwiftUI

class FeatureScope {
    
    func makeCounterConnector() -> CounterConnector {
        return CounterConnector()
    }
    
    class CounterConnector {
        private let connector: KeemunConnector<CounterFeatureParams>
        
        init() {
            self.connector = CounterFeatureParams().makeConnector(CounterStoreParams())
        }
        
        func makeView() -> CounterFeatureView {
            return .init(connector)
        }
    }
}
