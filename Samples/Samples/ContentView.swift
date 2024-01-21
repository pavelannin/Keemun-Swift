//
//  ContentView.swift
//  Samples
//
//  Created by Pavel Annin on 20.01.2024.
//

import SwiftUI

struct ContentView: View {
    let connector: FeatureScope.CounterConnector
    
    var body: some View {
        connector.makeView()
    }
}
