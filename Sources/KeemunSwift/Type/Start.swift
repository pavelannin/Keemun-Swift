import Foundation

public struct Start<State, Effect> {
    public let run: () -> Next<State, Effect>
    
    public init(_ run: @escaping () -> Next<State, Effect>) {
        self.run = run
    }
}
