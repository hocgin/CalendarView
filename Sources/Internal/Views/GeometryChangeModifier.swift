//
//  GeometryChangeModifier.swift
//  MijickCalendarView
//
//  Created by hocgin on 11/25/25.
//


import SwiftUI

struct GeometryChangeModifier: ViewModifier {
    @Binding var heights: [CGFloat]
    @Binding var firstVisibleIndex: Int
    @Binding var lastVisibleIndex: Int
    var scrollViewWidth: CGFloat
    var spacing: CGFloat
    var index: Int
    init(_ heights: Binding<[CGFloat]>,
         _ scrollViewWidth: CGFloat = .zero,
         index: Int = .zero,
         firstVisibleIndex: Binding<Int>,
         lastVisibleIndex: Binding<Int>,
         spacing: CGFloat = .zero
    ) {
        self._heights = heights
        self.index = index
        self._firstVisibleIndex = firstVisibleIndex
        self._lastVisibleIndex = lastVisibleIndex
        self.scrollViewWidth = scrollViewWidth
        self.spacing = spacing
    }
    

    func body(content: Content) -> some View {
        content.onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .scrollView)
            } action: { frame in
                if heights.count <= index {
                    heights.append(frame.height)
                } else if frame.height > heights[index] {
                    heights[index] = frame.height
                }
                if frame.minX <= spacing && frame.maxX > 0 {
                    firstVisibleIndex = index
                }
                if frame.minX < scrollViewWidth && frame.maxX >= scrollViewWidth - spacing {
                    lastVisibleIndex = index
                }
            }
    }
}

extension View {
    func trackGeometry(_ heights: Binding<[CGFloat]>,
                       _ scrollViewWidth: CGFloat = .zero,
                       index: Int = .zero,
                       firstVisibleIndex: Binding<Int>,
                       lastVisibleIndex: Binding<Int>,
                       spacing: CGFloat = .zero) -> some View {
        self.modifier(
            GeometryChangeModifier(
                heights,
                scrollViewWidth,
                index: index,
                firstVisibleIndex: firstVisibleIndex,
                lastVisibleIndex: lastVisibleIndex,
                spacing: spacing
            )
        )
    }
}
