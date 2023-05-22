//
//  ContentView.swift
//  TranscriSense
//
//  Created by carton22 on 2023/5/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ScrollView{
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Text("Welcome to TranscriSense!")
                Image(systemName: "snowflake")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
