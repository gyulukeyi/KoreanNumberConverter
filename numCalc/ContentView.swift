//
//  ContentView.swift
//  numCalc
//
//  Created by GYU MIN LEE on 10/14/19.
//  Copyright © 2019 GYU MIN LEE. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var numberInKorean: String = ""
    @State private var result: String = ""
    
    static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    var body: some View {
        VStack {
            Group{
                Text("Haha")
                    .font(.largeTitle)
                Text("I messed it up :/")
                    .padding(.bottom)
            }
            TextField("숫자를 입력해 주오", text: $numberInKorean)
                .padding()
            Text(self.result)
                .multilineTextAlignment(.leading)
                .padding()
            Button(action: {
                if (self.numberInKorean.range(of: #"^([0-9]+[조억만천백십]*)+[0-9]*$"#, options: .regularExpression) == nil) {
                    self.result = "숫자를 제대로 입력하시오. (예) 142조4923억4백만"
                }
                else{
                    let fmt = NumberFormatter()
                    fmt.numberStyle = .decimal
                    self.result = fmt.string(from: self.NumberParser(korNum: self.numberInKorean))!
                }
            }){
                Text("바꾸기")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    
            }
        }
    }
    
    func NumberParser(korNum: String!) -> NSDecimalNumber {
        let numberIndicators = [
            "조" : 12,
            "억" : 8,
            "만" : 4,
            "천" : 3,
            "백" : 2,
            "십" : 1
        ]
        var i = 0
        var j = 0
        var num:Decimal = 0
        
        for n in korNum.reversed(){
            if Array(numberIndicators.keys).contains(String(n)){
                if(numberIndicators[String(n)]! >= 4){
                    i = numberIndicators[String(n)]!
                    j = 0
                }
                else{
                    j = numberIndicators[String(n)]!
                }
            }
            else{
                num += Decimal(Int(String(n))!) * pow(10,i+j)
                j += 1
            }
        }
        return NSDecimalNumber(decimal: num)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
