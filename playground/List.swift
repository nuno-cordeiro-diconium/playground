//
//  List.swift
//  playground
//
//  Created by Nuno Cordeiro on 08/06/2023.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
            
            ForEach (Range(1...100)){ n in
                CellView(number: n)
            }
            
        }
        .listStyle(.grouped)
    }
}

struct CellView: View {
    
    let number: Int
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Evento \(number)").font(.title)
            Text("Descricao").font(.caption)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        
        
        .listRowBackground(Color.clear)
        
        
    }
}

struct List_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
