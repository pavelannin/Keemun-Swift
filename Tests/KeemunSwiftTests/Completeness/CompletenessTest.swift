import XCTest
import Combine
import CombineExpectations
@testable import Keemun

final class CompletenessTest: XCTestCase {
    private var cancellable: Set<AnyCancellable> = []
    
    func testRun() throws {
        let dispatchCount = 50
        let expected = CompletenessState(counter1: dispatchCount, counter2: dispatchCount, counter3: dispatchCount)
        let store = Keemun.Store(completenessStoreParams(repeatCount: dispatchCount))
        
        let recorder = store.state.record()
        let actual = try wait(for: recorder.availableElements, timeout: 2, description: "Actual")
        XCTAssertEqual(actual.last, expected)
    }
}
