//
//  SamplesTests.swift
//  SamplesTests
//
//  Created by Alexey Okhin on 16.03.2025.
//

import XCTest
@testable import Samples

final class CounterFeatureTests: XCTestCase {

    var feature: CounterFeature!

    override func setUp() {
        super.setUp()
        feature = CounterFeature()
    }

    override func tearDown() {
        feature = nil
        super.tearDown()
    }

    // MARK: - Тестирование синхронных операций
    func testIncrementSync() {
        let initialState = CounterFeature.State(syncCount: 0)
        let msg = CounterFeature.Msg.init(external: .incrementSync)

        let result = feature.storeParams.update.run(msg, initialState)

        XCTAssertEqual(result.state.syncCount, 1)
    }

    func testDecrementSync() {
        let initialState = CounterFeature.State(syncCount: 5)
        let msg = CounterFeature.Msg.init(external: .decrementSync)

        let result = feature.storeParams.update.run(msg, initialState)

        XCTAssertEqual(result.state.syncCount, 4)
    }

    // MARK: - Тестирование асинхронных операций
    func testIncrementAsync() async {
        let initialState = CounterFeature.State(asyncCount: 0)
        let msg = CounterFeature.Msg.init(external: .incrementAsync)
        // Создаем StoreParams
        let storeParams = feature.storeParams

        // Выполняем асинхронное обновление состояния
        let result = feature.storeParams.update.run(msg, initialState)

        // Проверяем, что флаг isAsyncRunning установлен в true
        XCTAssertTrue(result.state.isAsyncRunning)

        // Проверяем, что эффект был создан
        guard let effect = result.effects.first else {
            XCTFail("Effect should not be nil")
            return
        }

        // Запускаем эффект и проверяем результат
        let effectHandler = storeParams.effectHandlers.first!
        let effectResult = effectHandler.processing(effect)
        // Проверяем, что эффект вернул корректное значение
        switch effectResult {
        case .publisher:
            break

        case let .task(_, operation):
            await operation { msg in
                let updatedState = feature.storeParams.update.run(msg, result.state)
                XCTAssertEqual(updatedState.state.asyncCount, 1)
                XCTAssertFalse(updatedState.state.isAsyncRunning)
            }
        }
    }

    func testDecrementAsync() async {
        let initialState = CounterFeature.State(asyncCount: 5)
        let msg = CounterFeature.Msg.init(external: .decrementAsync)
        // Создаем StoreParams
        let storeParams = feature.storeParams

        // Выполняем асинхронное обновление состояния
        let result = feature.storeParams.update.run(msg, initialState)

        // Проверяем, что флаг isAsyncRunning установлен в true
        XCTAssertTrue(result.state.isAsyncRunning)

        // Проверяем, что эффект был создан
        guard let effect = result.effects.first else {
            XCTFail("Effect should not be nil")
            return
        }

        // Запускаем эффект и проверяем результат
        let effectHandler = storeParams.effectHandlers.first!
        let effectResult = effectHandler.processing(effect)
        // Проверяем, что эффект вернул корректное значение
        switch effectResult {
        case .publisher:
            break

        case let .task(_, operation):
            await operation { msg in
                let updatedState = feature.storeParams.update.run(msg, result.state)
                XCTAssertEqual(updatedState.state.asyncCount, 4)
                XCTAssertFalse(updatedState.state.isAsyncRunning)
            }
        }
    }

    // MARK: - Тестирование преобразования состояния в ViewState
    func testViewStateTransform() {
        let state = CounterFeature.State(
            syncCount: 10,
            asyncCount: 20,
            isAsyncRunning: true
        )

        let viewState = feature.featureParams.viewStateTransform.transform(state)

        XCTAssertEqual(viewState.syncCount, "10")
        XCTAssertEqual(viewState.asyncCount, "20")
        XCTAssertTrue(viewState.isAsyncRunning)
    }
}
