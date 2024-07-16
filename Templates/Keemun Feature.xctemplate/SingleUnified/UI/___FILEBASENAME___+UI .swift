import Foundation
import Keemun
import SwiftUI

struct ___VARIABLE_FeatureName___FeatureView: View {
    @ObservedObject private var connector: KeemunConnector<___VARIABLE_FeatureName___Feature.ViewState, ___VARIABLE_FeatureName___Feature.Msg>

    init(_ connector: KeemunConnector<___VARIABLE_FeatureName___Feature.ViewState, ___VARIABLE_FeatureName___Feature.Msg>) {
        self.connector = connector
    }

    var body: some View {
        MainView(state: connector.state)
    }
}

private struct MainView: View {
    let state: ___VARIABLE_FeatureName___Feature.ViewState

    var body: some View {
        Text("Implementation ___VARIABLE_FeatureName___Feature")
    }
}

private struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            state: ___VARIABLE_FeatureName___Feature.ViewState()
        )
    }
}
