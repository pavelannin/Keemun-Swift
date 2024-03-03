import Foundation

public struct Update<State, Msg, Effect> {
    public let run: (Msg, State) -> Next<State, Effect>
    
    public init(_ run: @escaping (Msg, State) -> Next<State, Effect>) {
        self.run = run
    }
}
