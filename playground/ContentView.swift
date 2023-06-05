//
//  ContentView.swift
//  playground
//
//  Created by Nuno Cordeiro on 29/05/2023.
//
import Foundation
import SwiftUI



struct ContentView: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button("The new Button") {
                showSheet = true
            }
            .actionSheet(isPresented: $showSheet, content: {
                ActionSheet(title: Text("My title"),
                            message: Text("kindly note this is a message"),
                            buttons: [])
            }).ignoresSafeArea()
            Button("Ana") {
                
            }
        }
    }
}



// TODO: Add HTML Tags later.
struct BottomSheetNotificationView: View {
    enum Content: Equatable {
        case `default`(title: String, description: String)
        case large(description: String)
    }

    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            switch content {
                case .default(title: let title, description: let description):
                    createDefaultStyledContent(title: title, description: description)
                case .large(description: let description):
                    createLargeStyledContent(description: description)
            }
        }
        .padding([.leading, .trailing], 20)
    }
}

private extension BottomSheetNotificationView {
    func createDefaultStyledContent(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            WeChargeUIComponents.Text.attributedHeader(title, fontSize: 24, fontWeight: .light)
                .foregroundColor(.black000)

            WeChargeUIComponents.Text.attributedText(description, fontSize: 16)
                .foregroundColor(.black000)
        }
    }

    func createLargeStyledContent(description: String) -> some View {
        WeChargeUIComponents.Text.attributedHeader(description, fontSize: 24, fontWeight: .light)
            .foregroundColor(.black000)
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





