//
//  ViewPlaceholder.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}




// MARK: Custom Redacted (iOS 13 Compatible) -

public enum RedactionReason {
    case placeholder
    case confidential
    case blurred
}

struct Placeholder: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.redacted(reason: RedactionReasons.placeholder)
        } else {
            content
                .accessibility(label: Text("Placeholder"))
                .opacity(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                    .fill(Color.black.opacity(0.1))
                    .padding(.vertical, 4.5)
                )
        }
    }
}

struct Confidential: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Confidential"))
            .opacity(0)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.black.opacity(1))
                    .padding(.vertical, 4.5)
            )
    }
}

struct Blurred: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Blurred"))
            .blur(radius: 4)
    }
}

struct RedactableView: ViewModifier {
    let reason: RedactionReason?

    @ViewBuilder
    func body(content: Content) -> some View {
        switch reason {
        case .placeholder:
            content
                .modifier(Placeholder())
            
        case .confidential:
            content
                .modifier(Confidential())
            
        case .blurred:
            content
                .modifier(Blurred())
            
        case nil:
            content
        }
    }
}

extension View {
    
    func redacted(reason: RedactionReason?) -> some View {
        self.modifier(RedactableView(reason: reason))
    }
}
