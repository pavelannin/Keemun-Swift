import Foundation
import Combine

/// Represents a holder of `Store`.
public class KeemunConnector<ViewState, ExternalMsg>: ObservableObject {
    /// Current state for user view.
    @Published public private(set) var state: ViewState
    
    private let dispath: (ExternalMsg) -> Void
    private var cancellable: Set<AnyCancellable> = []
    
    public init<State, Msg, Effect>(
        store: Store<State, Msg, Effect>,
        featureParams: FeatureParams<State, Msg, ViewState, ExternalMsg>
    ) {
        self.dispath = { msg in store.dispatch(featureParams.messageTransform(msg)) }
        self.state = featureParams.viewStateTransform.transform(store.currentState)
        
        let viewStateQueue = DispatchQueue(label: "keemun.viewStateQueue", qos: .userInitiated)
        store.state
            .receive(on: viewStateQueue)
            .map(featureParams.viewStateTransform.transform)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.state = $0
            }
            .store(in: &cancellable)
    }
    
    /// Sending messages asynchronously.
    public func dispatch(_ msg: ExternalMsg) {
        dispath(msg)
    }
}

public extension KeemunConnector {
    convenience init<State, Msg, Effect>(
        storeParams: StoreParams<State, Msg, Effect>,
        featureParams: FeatureParams<State, Msg, ViewState, ExternalMsg>
    ) {
        self.init(store: Store(storeParams), featureParams: featureParams)
    }
}
