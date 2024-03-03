import Foundation
import Combine

/// Represents a holder of `Store`.
public class KeemunConnector<Params: FeatureParams>: ObservableObject {
    public typealias ViewState = Params.ViewState
    public typealias ExternalMsg = Params.ExternalMsg
    public typealias StoreParams = Params.SParams
    
    /// Current state for user view.
    @Published public private(set) var state: ViewState
    
    private let params: Params
    private let store: Store<StoreParams>
    private var cancellable: Set<AnyCancellable> = []
    
    public init(_ store: Store<StoreParams>, _ featureParams: Params) {
        self.store = store
        self.params = featureParams
        
        self.state = self.params.stateTransform(self.store.currentState)
        self.store.state
            .map(self.params.stateTransform)
            .subscribe(on: Params.stateTransformScheduler)
            .receive(on: DispatchQueue.main)
            .sink { viewState in self.state = viewState }
            .store(in: &cancellable)
    }
    
    /// Sending messages asynchronously.
    public func dispatch(_ msg: ExternalMsg) {
        self.store.dispatch(Params.msgMapper(msg))
    }
}

public extension FeatureParams {
    /// Creates a new instance of `KeemunConnector` from `FeatureParams`.
    func makeConnector(_ store: Store<SParams>) -> KeemunConnector<Self> {
        return KeemunConnector<Self>(store, self)
    }
    
    /// Creates a new instance of `KeemunConnector` from `FeatureParams`.
    func makeConnector(_ storeParams: SParams) -> KeemunConnector<Self>  {
        return KeemunConnector<Self>(storeParams.makeStore(), self)
    }
}
