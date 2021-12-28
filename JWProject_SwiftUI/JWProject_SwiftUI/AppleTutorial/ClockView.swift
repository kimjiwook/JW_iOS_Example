//
//  ClockView.swift
//  JWProject_SwiftUI
//
//  Created by iOS_Mac Mini on 2021/12/28.
//

import SwiftUI

// 시간바뀔때마다 시간값 넘겨줘보기
typealias clockTimeString = (_ timeString:String) -> Void

// 시계 뷰
struct ClockView: View {
    var width = UIScreen.main.bounds.width
    @State var timeText:String = "00:00:00"
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            ZStack {
                ClockBGView() // 1. 배경부분
                ClockBarView(didChange:({ timeString in
                    print("\(timeString)")
                    timeText = timeString // 셋팅
                })) // 2. 시간 나오는 부분
                
            }.frame(width: width - 80, height: width - 80)
            Text(timeText)
            Spacer(minLength: 0)
        }
    }
}


struct ClockView_Previews: PreviewProvider {
    
    static var previews: some View {
        ClockView()
    }
}

// ----------------------------- //
// #. 관련 모델 부분
struct TimeVM {
    var min:Int
    var sec:Int
    var hour:Int
}

// ----------------------------- //
// 1. BG 부분
struct ClockBGView: View {
    var width = UIScreen.main.bounds.width
    var body: some View {
        // 배경부분
        Circle()
            .fill(.gray)
            .opacity(0.3)
        
        // 시간부분 그리기
        ForEach(0..<60, id:\.self) { i in
            Rectangle()
                .fill(Color.primary)
                .frame(width: 2, height: (i % 5) == 0 ? 15 : 5) // 5분단위 체크
                .offset(y: (width - 110) / 2)
                .rotationEffect(.init(degrees: Double(i) * 6)) // 그릴때 각도
        }
    }
}

// 2. 시계침 부분 그리기
struct ClockBarView: View {
    var width = UIScreen.main.bounds.width
    @State var currentTime = TimeVM(min: 0, sec: 0, hour: 0) { // 시간 상태값
        didSet {
            // print("시간값이 변하고 있어요. \(currentTime.hour):\(currentTime.min):\(currentTime.sec)")
            // 변경된 시간값 전달해보기.
            self.didChange?("\(currentTime.hour):\(currentTime.min):\(currentTime.sec)")
        }
    }
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect() // 타이머 만들기
    
    // 전달클로져
    @State var didChange:clockTimeString?
    
    var body: some View {
        ZStack {
            // 초
            Rectangle()
                .fill(.blue)
                .frame(width: 2, height: (width - 180) / 2)
                .offset(y: -(width - 180) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.sec) * 6)) // 1초당 6도
            
            // 분
            Rectangle()
                .fill(Color.primary)
                .frame(width: 4, height: (width - 200) / 2)
                .offset(y: -(width - 200) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.min) * 6)) // 1분당 6도
            
            // 시
            Rectangle()
                .fill(Color.primary)
                .frame(width: 4.5, height: (width - 240) / 2)
                .offset(y: -(width - 180) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.hour) * 30)) // 1시간당 30도
            
            // 점
            Circle()
                .fill(Color.primary)
                .frame(width: 15, height: 15)
        }
        // View 시작시
        .onAppear(perform: {
            timeCheck()
        })
        // 리시버 감시
        .onReceive(receiver) { (_) in
            timeCheck()
        }
    }
    
    /// 시간 체크하는 함수
    func timeCheck() {
        let calender = Calendar.current

        let min = calender.component(.minute, from: Date())
        let sec = calender.component(.second, from: Date())
        let hour = calender.component(.hour, from: Date())

        withAnimation(Animation.linear(duration: 0.01)) {
            self.currentTime = TimeVM(min: min, sec: sec, hour: hour)
        }
    }
}

extension ClockBarView {
    /// 1. 클로져 지원해주기.(음... Struct라 또 이게 지원이..)
    public func didChange(closure: @escaping clockTimeString) -> Self {
        self.didChange = closure
        return self
    }
}
