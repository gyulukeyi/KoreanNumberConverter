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
    @State private var resultSpelledOut: String = ""
    
    static let numberToDecimal: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    static let numberToSpell: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .spellOut
        return f
    }()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.blue)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    //TODO: make this fancier
                    Text("숫자변환기")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                    Text("숫자를 변환하오")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                        .foregroundColor(Color.white)
                }
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
            Spacer()
                .frame(maxHeight: 300.0)
            VStack {
                TextField("그대 숫자를 입력해 주오", text: $numberInKorean)
                    .padding()
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    //TODO: update result upon pressing enter
                Text(self.result)
                    .multilineTextAlignment(.center)
                Text(self.resultSpelledOut)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    if (self.numberInKorean.range(of: #"^([0-9]+[조억만천백십]*)+[0-9]*$"#, options: .regularExpression) == nil) {
                        self.result = "숫자를 제대로 입력하시오. (예) 142조4923억4백만"
                    }
                    else{
                        self.result = ContentView.self.numberToDecimal.string(from: self.NumberParser(korNum: self.numberInKorean))!
                        self.resultSpelledOut = ContentView.self.numberToSpell.string(from: self.NumberParser(korNum: self.numberInKorean))!
                    }
                }){
                    Text("바꾸기")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .edgesIgnoringSafeArea(.all)
                        
                }
            }
            
        }
    }
    
    func NumberParser(korNum: String!) -> NSDecimalNumber {
        //TODO: revise the method so that it may produce value from a unit without 1 e.g. 백만 -> 1,000,000
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
