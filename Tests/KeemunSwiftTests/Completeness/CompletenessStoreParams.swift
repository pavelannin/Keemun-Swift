import Foundation
import Combine
@testable import Keemun

struct CompletenessStoreParams: StoreParams {
    let repeatCount: Int
    
    func start() -> Start<Self> {
        .next(
            .init(counter1: 0, counter2: 0, counter3: 0),
            effects: [
                .startIncConter1(repeatCount: repeatCount),
                .startIncConter2(repeatCount: repeatCount),
                .startIncConter3(repeatCount: repeatCount)
            ]
        )
    }
    
    static func update(for msg: Msg, state: State) -> Update<Self> {
        switch msg {
        case .incCounter1:
            return .next(state) { $0.counter1 += 1 }
        case .incCounter2:
            return .next(state) { $0.counter2 += 1 }
        case .incCounter3:
            return .next(state) { $0.counter3 += 1 }
        }
    }
    
    func effectHandler(for effect: Effect, dispatch: @escaping (Msg) -> Void) async {
        switch effect {
        case .startIncConter1(repeatCount: let repeatCount):
            let _ = (1...repeatCount).publisher.sink { _ in dispatch(.incCounter1) }
        case .startIncConter2(repeatCount: let repeatCount):
            let _ = (1...repeatCount).publisher.sink { _ in dispatch(.incCounter2) }
        case .startIncConter3(repeatCount: let repeatCount):
            let _ = (1...repeatCount).publisher.sink { _ in dispatch(.incCounter3) }
        }
    }
    
    struct State: Equatable {
        var counter1: Int
        var counter2: Int
        var counter3: Int
    }
    
    enum Msg {
        case incCounter1
        case incCounter2
        case incCounter3
    }
    
    enum Effect {
        case startIncConter1(repeatCount: Int)
        case startIncConter2(repeatCount: Int)
        case startIncConter3(repeatCount: Int)
    }
}
