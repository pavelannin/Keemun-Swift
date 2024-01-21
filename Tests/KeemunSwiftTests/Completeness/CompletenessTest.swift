import XCTest
import Combine
import CombineExpectations
@testable import KeemunSwift

final class CompletenessTest: XCTestCase {
    private var cancellable: Set<AnyCancellable> = []
    
    func testRun() throws {
        let dispatchCount = 50
        let expected = CompletenessStoreParams.State(counter1: dispatchCount, counter2: dispatchCount, counter3: dispatchCount)
        let store = CompletenessStoreParams(repeatCount: dispatchCount).makeStore()
        
        let recorder = store.state.record()
        let actual = try wait(for: recorder.availableElements, timeout: 1, description: "Actual")
        XCTAssertEqual(actual.last, expected)
    }
}
