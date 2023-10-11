//
//  ContentView.swift
//  SwiftMacrosExplanation
//
//  Created by Ahmed Amin on 11/10/2023.
//

import SwiftUI
import Explanation

struct ContentView: View {
    var body: some View {
        VStack {
            Link(destination: #URL("https://github.com/Ahmed-Amin-Hassan-Ismail")
                 , label: {
                Text("My GitHub")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
