import Foundation
import Keemun
import SwiftUI

struct CounterFeatureView: View {
    @ObservedObject private var connector: KeemunConnector<CounterFeature.ViewState, CounterFeature.ExternalMsg>
    
    init(_ connector: KeemunConnector<CounterFeature.ViewState, CounterFeature.ExternalMsg>) {
        self.connector = connector
    }
    
    var body: some View {
        MainView(
            state: connector.state,
            syncIncrementAction: { connector.dispatch(.incrementSync) },
            syncDecrementAction: { connector.dispatch(.decrementSync) },
            asyncIncrementAction: { connector.dispatch(.incrementAsync) },
            asyncDecrementAction: { connector.dispatch(.decrementAsync) }
        )
    }
}

private struct MainView: View {
    let state: CounterFeature.ViewState
    let syncIncrementAction: () -> Void
    let syncDecrementAction: () -> Void
    let asyncIncrementAction: () -> Void
    let asyncDecrementAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 8) {
                CounterView(
                    title: "Sync",
                    value: state.syncCount,
                    isLoading: false,
                    incrementAction: syncIncrementAction,
                    decrementAction: syncDecrementAction
                ).frame(width: geometry.size.width * 0.5)
                CounterView(
                    title: "Async",
                    value: state.asyncCount,
                    isLoading: state.isAsyncRunning,
                    incrementAction: asyncIncrementAction,
                    decrementAction: asyncDecrementAction
                ).frame(width: geometry.size.width * 0.5)
            }.frame(height: geometry.size.height)
        }
    }
}

private struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            state: CounterFeature.ViewState(
                syncCount: "10",
                asyncCount: "10",
                isAsyncRunning: false
            ),
            syncIncrementAction: {},
            syncDecrementAction: {},
            asyncIncrementAction: {},
            asyncDecrementAction: {}
        )
    }
}

private struct CounterView: View {
    let title: String
    let value: String
    let isLoading: Bool
    let incrementAction: () -> Void
    let decrementAction: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title).font(.title)
            Button("+", action: incrementAction).disabled(isLoading).font(.title3)
            ZStack {
                Text(value).font(.title2)
                if isLoading { ProgressView() }
            }
            Button("-", action: decrementAction).disabled(isLoading).font(.title3)
        }
    }
}

private struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            title: "Title",
            value: "10",
            isLoading: true,
            incrementAction: {},
            decrementAction: {}
        )
    }
}
