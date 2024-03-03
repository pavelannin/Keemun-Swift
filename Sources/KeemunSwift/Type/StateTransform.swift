import Foundation
import Dispatch

public struct StateTransform<State, OutState> {
    public let transform: (State) -> OutState
    
    public init(_ transform: @escaping (State) -> OutState) {
        self.transform = transform
    }
}
