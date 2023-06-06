//
//  ContentView.swift
//  playground
//
//  Created by Nuno Cordeiro on 29/05/2023.
//
import Foundation
import SwiftUI



struct ContentView: View {
  @State var showInfoModalView: Bool = false
  
  var body: some View {
    VStack(spacing: 50) {
      Text("Main View")
        .font(.largeTitle)
      
      Button(action: {
        showInfoModalView = true
      }, label: {
        Label("Show Info View", systemImage: "info.circle")
      })
    }
    .sheet(isPresented: $showInfoModalView) {
        InfoView()
    }.frame(maxHeight: 200)
  }
}


struct InfoView: View {
    var body: some View {
        VStack(spacing: 50)  {
            Text("Nuno")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





