//
//  TimePickerClockView.swift.swift
//  JWProject_SwiftUI
//
//  Created by JW_Macbook on 2021/12/29.
//
/*
 Custom Time Picker (아날로그 시계 버전)
 */

import SwiftUI

struct TimePickerClockView: View {
    @StateObject var vm = DateVM()
    var body: some View {
        ZStack {
            
            Text(vm.seletedDate, style: .time)
                .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    vm.setTime() // 시간설정
                    withAnimation(.spring()) {
                        vm.showPicker.toggle()
                    }
                }
            
            if vm.showPicker {
                // Picker View3
                VStack {
                    HStack(spacing:18) {
                        Spacer()
//                        /// 날짜 피커
//                        DatePicker("날짜선택(기본피커)", selection: $vm.seletedDate, displayedComponents: .hourAndMinute)
//                            .font(.largeTitle)
//                            .pickerStyle(.inline)
//                            .colorMultiply(.white)
//                            .colorInvert()
                        // 시간설정뷰
                        HStack(spacing:0) {
                            Text("\(vm.hour):")
                                .font(.largeTitle)
                                .fontWeight(vm.changeToMin ? .light : .bold)
                                .onTapGesture {
                                    vm.angle = Double(vm.hour * 30) // 시간값 디폴트 설정
                                    vm.changeToMin = false // 상태값 변경
                                }

                            Text("\(vm.min < 10 ? "0" : "")\(vm.min)")
                                .font(.largeTitle)
                                .fontWeight(vm.changeToMin ? .bold : .light)
                                .onTapGesture {
                                    vm.angle = Double(vm.min * 6)
                                    vm.changeToMin = true // 상태값 변경
                                }
                        }
                        VStack(spacing:8) {
                            Text("AM")
                                .font(.title2)
                                .fontWeight(vm.symbol == "AM" ? .bold : .light)
                                .onTapGesture {
                                    vm.symbol = "AM" // 상태값 변경
                                }

                            Text("PM")
                                .font(.title2)
                                .fontWeight(vm.symbol == "PM" ? .bold : .light)
                                .onTapGesture {
                                    vm.symbol = "PM" // 상태값 변경
                                }
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(height: 100)
                    
                    // 시계 슬라이더 뷰
                    TimeSliderView()
                    
                    // 확인 버튼 추가하기
                    HStack {
                        Spacer()
                        Button {
                            vm.generateTime()
                        } label: {
                            Text("Save")
                                .fontWeight(.bold)
                        }
                    }.padding()
                }
                // 최대가로값 잡아주기
                //.frame(width: getWidth() - 120)
                .frame(width: 300) // 폰/패드 사이즈 문제로 고정시킴.
                .background(.black)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3).ignoresSafeArea().onTapGesture {
                    withAnimation(.spring()) {
                        vm.showPicker.toggle()
                        vm.changeToMin = false
                    }
                })
                .environmentObject(vm) // 하위 객체 값 전달해주기
            }
            
        }
        
        
    }
}

struct TimePickerClockView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerClockView()
    }
}


//MARK: - Data관련
class DateVM: ObservableObject {
    // 날짜 선택시마다.
    @Published var seletedDate = Date() {
        didSet {
            self.setTime()
        }
    }
    @Published var showPicker = false
    
    // 시, 분 선택시마다
    @Published var hour:Int = 12
    @Published var min:Int = 0
    
    // 스위치 관련 (시간, 분)
    @Published var changeToMin = false
    // AM to TM
    @Published var symbol = "AM"
    
    // angle 저장
    @Published var angle:Double = 0
    
    func generateTime() {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        // 24시간 체크
        var currentHourValue = hour
        if symbol == "AM" {
            if hour >= 12 {
                currentHourValue = hour - 12
            } else {
                currentHourValue = hour
            }
        } else {
            if hour >= 12 {
                currentHourValue = hour
            } else {
                currentHourValue = hour + 12
            }
        }
        
        // 완료 처리.
        if let date = format.date(from: "\(currentHourValue):\(min)") {
            self.seletedDate = date
            withAnimation {
                showPicker.toggle()
                changeToMin = false
            }
        }
    }
    
    /// 데이트 값 셋팅
    func setSeletedDate() {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        // 24시간 체크
        var currentHourValue = hour
        if symbol == "AM" {
            if hour >= 12 {
                currentHourValue = hour - 12
            } else {
                currentHourValue = hour
            }
        } else {
            if hour >= 12 {
                currentHourValue = hour
            } else {
                currentHourValue = hour + 12
            }
        }
        
        // 완료 처리.
        if let date = format.date(from: "\(currentHourValue):\(min)") {
            self.seletedDate = date
        }
    }
    
    /// 시, 분 셋팅
    func setTime() {
        let calender = Calendar.current
        
        // 24 시간이여서 확인
        // 24시간 체크
        hour = calender.component(.hour, from: seletedDate)
        symbol = hour <= 12 ? "AM" : "PM"
        
        if hour >= 12 {
            hour = hour - 12
        }
        
        
        min = calender.component(.minute, from: seletedDate)
        
        
        if changeToMin {
            angle = Double(min * 6) // 디폴트 셋팅
        } else {
            angle = Double(hour * 30)
        }
    }
}

//MARK: - View 관련
extension View{
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

struct TimeSliderView: View {
    @EnvironmentObject var vm: DateVM
    
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                let widdth = reader.frame(in: .global).width / 2
                
                // 선택 점
                Circle()
                    .fill(.blue)
                    .frame(width: 40, height: 40)
                    .offset(x: widdth - 50)
                    .rotationEffect(.init(degrees: vm.angle)) // 해당 값에 따른이동
                // 드레그 제스쳐 추가
                    .gesture(
                        DragGesture()
                            .onChanged({ value in onChanged(value)})
                            .onEnded({ value in onEnd(value)})
                    )
                    .rotationEffect(.init(degrees: -90))
                
                // 배경 (숫자)
                
                ForEach(1...12, id: \.self) { index in
                    VStack {
                        Text("\(vm.changeToMin ? index * 5 : index)")
                            .font(.title3)
                            .foregroundColor(.white)
                        // 글씨는 정방향
                            .rotationEffect(.init(degrees: Double(-index) * 30))
                            
                    }
                    .offset(y: -widdth + 50)
                    // 위치 로테이션 추가.
                    .rotationEffect(.init(degrees: Double(index) * 30))
                }
                
                // 로고 넣기
                Image("단체005", bundle: nil)
                    .resizable()
                    .frame(width: 100, height: 100)
                
                // 가운데 점 + 시계바늘
                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
                    .overlay(
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 2, height: widdth / 2)
                        ,alignment: .bottom
                    )
                    .rotationEffect(.init(degrees: vm.angle)) // 해당 값에 따른이동
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
        // 높이값
        .frame(height: 300)
    }
    
    // 제스쳐 부분 추가.
    
    func onChanged(_ value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // 선택원 크기 40
        // radius = 20
        let radians = atan2(vector.dy - 20, vector.dx - 20)
        var angle = radians * 180 / .pi
        
        if angle < 0 {
            angle = 360 + angle
        }
        
        vm.angle = angle // 값 저장
        
        // 시간 선택시
        if !vm.changeToMin {
            // 움직이는 범위 정하기 (360/12 = 30도씩)
            let roundValue = 30 * Int(round(vm.angle / 30))
            vm.angle = Double(roundValue)
            
            // 시간 셋팅
            vm.hour = Int(vm.angle / 30)
        }
        
        // 분 선택시
        else {
            // 1분 단위 선택하게 설정함.
            let progress = vm.angle / 360
            vm.min = Int(progress * 60)
        }
    }
    
    func onEnd(_ value: DragGesture.Value) {
        
        if !vm.changeToMin {
            withAnimation {
                vm.angle = Double(vm.min * 6) // 디폴트 셋팅
                vm.changeToMin = true
            }
        }
        
        /// 데이트 값 최신화
        vm.setSeletedDate()
    }
}
