//
//  AppleTutorialView.swift
//  JWProject_SwiftUI
//
//  Created by iOS_Mac Mini on 2021/12/27.
//

import SwiftUI

struct AppleTutorialView: View {
    var body: some View {
        VStack {
            Text("Hello, World!_AppleTutorial")
                .font(.title)
            .multilineTextAlignment(.leading)
            
            HStack {
                Text("첫번째 라벨")
                Spacer()
                Text("두번째 라벨")
            }.padding()
        }.padding()
    }
}

struct AppleTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        AppleTutorialView()
    }
}
