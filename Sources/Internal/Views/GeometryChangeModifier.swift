//
//  GeometryChangeModifier.swift
//  MijickCalendarView
//
//  Created by hocgin on 11/25/25.
//


import SwiftUI

struct GeometryChangeModifier: ViewModifier {
    @Binding var height: CGFloat
    init(_ height: Binding<CGFloat>) {
        self._height = height
    }
    

    func body(content: Content) -> some View {
        content.onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .scrollView)
            } action: { frame in
                guard height < frame.height else { return }
                height = frame.height
            }
    }
}

extension View {
    func trackGeometry(_ height: Binding<CGFloat>) -> some View {
        self.modifier(GeometryChangeModifier(height))
    }
}
