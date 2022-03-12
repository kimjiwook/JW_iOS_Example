//
//  ContentView.swift
//  JWProject_SwiftUI
//
//  Created by JW_Macbook on 2021/12/27.
//

import SwiftUI

/// 최초 시작 뷰
struct ContentView: View {
    
    @StateObject var vm = ContentVM()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(vm.listItem) { listVM in
                        NavigationLink(destination: ClockView()) {
                            ContentItemView(listVM: listVM)
                        }   
                    }
                }
            }
        }.navigationTitle("SwiftUI 샘플 모음집")
    }
}

/// Item View
struct ContentItemView:View {
    
    @StateObject var listVM = ContentItemVM()
    
    var body: some View {
        HStack {
            Text(listVM.title)
            Text(listVM.content)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
