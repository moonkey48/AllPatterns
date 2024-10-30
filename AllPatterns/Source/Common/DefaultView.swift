//
//  DefaultView.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 10/31/24.
//

import SwiftUI

struct DefaultView: View {
    var action: (() -> Void)?
    var title: String = "Default View"

    var body: some View {
        VStack {
            Text(title)
            if let action {
                Button {
                    action()
                } label: {
                    Text("action")
                }
            }
        }
    }
}

#Preview {
    DefaultView()
}
