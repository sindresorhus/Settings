//
//  PreferenceSection.swift
//  Preferences
//
//  Created by Kacper on 19/02/2020.
//

import SwiftUI

/**
    Represents section with left aligned title and optional bottom divider (present by default).
 */
@available(macOS 10.15, *)
public struct PreferenceSection: View {
    struct LabelWidthPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        
        static var defaultValue: CGFloat = 0.0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            let next = nextValue()
            value = next > value ? next : value
        }
    }
    
    struct LabelOverlay: View {
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: LabelWidthPreferenceKey.self, value: geometry.size.width)
            }
        }
    }
    
    struct LabelWidthModifier: ViewModifier {
        @Binding var maxWidth: CGFloat
        
        func body(content: Content) -> some View {
            content
                .onPreferenceChange(LabelWidthPreferenceKey.self) { maxWidth in
                    self.maxWidth = maxWidth
                }
        }
    }
    
    public let label: AnyView
    public let content: AnyView
    public let bottomDivider: Bool
    
    public init<Label: View, Content: View>(bottomDivider: Bool = false,
                                            label: @escaping () -> Label,
                                            content: @escaping () -> Content) {
        self.label = label()
            .overlay(LabelOverlay())
            .eraseToAnyView()
        self.bottomDivider = bottomDivider
        self.content = content().eraseToAnyView()
    }
    
    public init<Content: View>(title: String, bottomDivider: Bool = true, content: @escaping () -> Content) {
        let textLabel = {
            Text(title)
                .font(.system(size: 13.0))
                .overlay(LabelOverlay())
                .eraseToAnyView()
        }
        self.init(bottomDivider: bottomDivider, label: textLabel, content: content)
    }

    public var body: some View {
        HStack(alignment: .top) {
            label
                .alignmentGuide(.preferenceSectionLabel, computeValue: { $0[.trailing] })
            content
            Spacer()
        }
    }
}

@available(macOS 10.15, *)
extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
