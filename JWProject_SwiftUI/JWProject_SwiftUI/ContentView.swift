//
//  ContentView.swift
//  JWProject_SwiftUI
//
//  Created by JW_Macbook on 2021/12/27.
//

import SwiftUI

/// 최초 시작 뷰
struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ContentItemView()
            }
        }
    }
}

/// Item View
struct ContentItemView:View {
    var body: some View {
        HStack {
            Text("4444")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
