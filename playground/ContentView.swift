//
//  ContentView.swift
//  playground
//
//  Created by Nuno Cordeiro on 29/05/2023.
//
import Foundation
import SwiftUI


struct ContentView: View {
    
    @State var isShowingBottomSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Button {
                    isShowingBottomSheet = true
                } label: {
                    Text("Show bottom sheet")
                }.buttonStyle(.borderedProminent)
            }
            let buttons: [newButton] =
                [.init(label: "Nuno", customAction: { print("Hello Wooorld!!!") })]
            BottomSheetView(title: "This is my title", description: "Long description of the popUp goes here. You can customize this text", isShowing: $isShowingBottomSheet, buttons: buttons)
        }
    }
}


protocol newButtonDelegate {
    func didTapped()
}

struct newButton: View, Identifiable {
    let id = UUID()
    var label: String
    var customAction: (()->Void)
    var delegate: newButtonDelegate?
    
    var body: some View {
        Button {
            customAction()
            delegate?.didTapped()
        } label: {
            Text(label)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .clipShape(Capsule())
    }
}


struct BottomSheetView: View, newButtonDelegate {

    let title: String
    let description: String
    
    @Binding var isShowing: Bool
    var buttons = [newButton]()
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                VStack {
                    Text(title).font(.title).padding()
                    Text(description)
                    ForEach(buttons) { button in
                        newButton(label: button.label,
                                         customAction: button.customAction,
                                         delegate: self)
                        .padding(.top)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 50)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .background(.white)
                .cornerRadius(16)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }

    func didTapped() {
        isShowing = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

