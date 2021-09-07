//
//  ViewExtension.swift
//
//  Created by Roy Rao on 2021/4/12.
//

import SwiftUI
import Combine

extension View {
    
    /**
     * Display your `View` conditionally.
     *
     * - Parameters:
     *      - conditional: The condition you wanna check.
     *      - ifTure: What you wanna do if checked true.
     *      - ifFalse: What you wanna do if checked false.
     */
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, if ifTure: ((Self) -> Content)?, else ifFalse: ((Self) -> Content)?) -> some View {
        if conditional {
            if ifTure != nil {
                ifTure!(self)
            } else {
                self
            }
        } else {
            if ifFalse != nil {
                ifFalse!(self)
            } else {
                self
            }
        }
    }
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            } else {
                EmptyView()
            }
        } else {
            self
        }
    }
    
    /// A backwards compatible wrapper for iOS 14 `onChange`.
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
    
    /// Set if enable the scroll function in `List`s.
    func scrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}
