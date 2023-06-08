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
    @State var tappedButtonIndex: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                if tappedButtonIndex != 0 {
                    Text("You just tapped button \(tappedButtonIndex)").padding()
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Custom made Pop up...\n without a dead end!")
                    .padding(.bottom, 40)
                    .padding(.top, 10)
                Button {
                    isShowingBottomSheet = true
                } label: {
                    Text("Pop it up!")
                }.buttonStyle(.borderedProminent)
            }
            let buttons: [ActionButton] =
                [
                    .init(label: "Touch button 1", customAction: {
                    tappedButtonIndex = 1
                    }, style: .primary),
                    .init(label: "Cancel", customAction: {
                    tappedButtonIndex = 2
                    }, style: .cancel)
                ]
            
            BottomSheetView(title: "This is my title", description: "Long description of the popUp goes here. You can customize this text", isShowing: $isShowingBottomSheet, buttons: buttons)            
        }
    }
}


protocol ActionButtonDelegate {
    func didTapped()
}

struct ActionButton: View, Identifiable {
    
    enum actionButtonStyle {
        case primary, cancel
    }
    
    let id = UUID()
    var label: String
    var customAction: (()->Void)
    let style: actionButtonStyle
    var delegate: ActionButtonDelegate?
    
    private let cornerRadius = 20.0
    
    var body: some View {
        Button {
            customAction()
            delegate?.didTapped()
        } label: {
            Text(label)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.red, lineWidth: style == .cancel ? 4 : 0)
                    )
                .foregroundColor(style == .cancel ? .red : .white)
                .background(style == .cancel ? .white : .blue)
                .cornerRadius(cornerRadius)
        }
    }
}


struct BottomSheetView: View, ActionButtonDelegate {

    let title: String
    let description: String
    
    @Binding var isShowing: Bool
    var buttons = [ActionButton]()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
//                    .onTapGesture {
//                        withAnimation {
//                            isShowing = false
//                        }
//                    }
                VStack {
                    Text(title).font(.title).padding()
                    Text(description)
                    ForEach(buttons) { button in
                        ActionButton(label: button.label,
                                     customAction: button.customAction,
                                     style: button.style,
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

