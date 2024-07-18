//
//  DestinationSearchView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.07.24.
//

import SwiftUI

struct DestinationSearchView: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "xmark.circle")
                .imageScale(.large)
                .foregroundStyle(.black)
        }
        
        VStack {
            Text("Where to? ")
        }
    }
}

#Preview {
    DestinationSearchView()
}
