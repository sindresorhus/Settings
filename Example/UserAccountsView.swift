//
//  UserAccountsView.swift
//  Preferences
//
//  Created by Kacper on 06/01/2020.
//

import SwiftUI
import Preferences

/**
    Function wrapping SwiftUI into PreferencePane, which is mimicing view controller's default construction syntax
 */
func UserAccountsPreferenceViewController() -> PreferencePane {
    let icon = NSImage(named: NSImage.userAccountsName)!
    return PreferencePaneHostingController(identifier: .userAccounts,
                                           title: "User Accounts",
                                           toolbarIcon: icon,
                                           content: UserAccountsView())
}

/**
    Extension with custom alignment guide for section title labels
 */
extension HorizontalAlignment {
    private enum PreferenceLabelAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }
    
    static let preferenceLabel = HorizontalAlignment(PreferenceLabelAlignment.self)
}

/**
    Main view of User Accounts preference screen
 */
struct UserAccountsView: View {
    @State var isOn1: Bool = true
    @State var isOn2: Bool = false
    @State var selection1: Int = 1
    @State var selection2: Int = 0
        
    var body: some View {
        VStack(alignment: .preferenceLabel) {
            CheckboxSectionView(isOn1: self.$isOn1, isOn2: self.$isOn2)
            Divider()
                .frame(width: width, height: 20.0)
                .alignmentGuide(.preferenceLabel, computeValue: { $0[.leading] + 104.0 })
            RadioSectionView(selection: self.$selection1)
            Divider()
                .frame(height: 20.0)
                .alignmentGuide(.preferenceLabel, computeValue: { $0[.leading] + 104.0 })
            PickerSectionView(selection: self.$selection2)
        }
        .frame(width: width, alignment: .leading)
        .padding(paddingInsets)
    }
    
    var width: CGFloat {
        return 510.0
    }
    
    var paddingInsets: EdgeInsets {
        EdgeInsets(top: 20.0, leading: 30.0, bottom: 20.0, trailing: 30.0)
    }
}

// Some example sections with various input methods
struct RadioSectionView: View {
    @Binding var selection: Int
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Show scroll bars:")
                .alignmentGuide(.preferenceLabel, computeValue: { $0[.trailing] })
            Picker(selection: self.$selection, label: EmptyView()) {
                 Text("When scrolling").tag(0)
                 Text("Always").tag(1)
            }
            .fixedSize()
            .pickerStyle(RadioGroupPickerStyle())
        }
    }
}

struct CheckboxSectionView: View {
    @Binding var isOn1: Bool
    @Binding var isOn2: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Permissions:")
                .alignmentGuide(.preferenceLabel, computeValue: { $0[.trailing] })
            VStack(alignment: .leading) {
                VStack() {
                    Toggle("Allow user to administer this computer", isOn: self.$isOn1)
                        .toggleStyle(CheckboxToggleStyle())
                    Text("Administrator has root access to this machine")
                        .font(.system(size: 11.0))
                        .foregroundColor(.gray)
                }
                Toggle("Allow user to access every file", isOn: self.$isOn2)
                    .toggleStyle(CheckboxToggleStyle())
            }
        }
    }
}
 
struct PickerSectionView: View {
    @Binding var selection: Int
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Preview mode:")
                .alignmentGuide(.preferenceLabel, computeValue: { $0[.trailing] })
            VStack(alignment: .leading) {
                Picker(selection: self.$selection, label: EmptyView()) {
                     Text("Automatic").tag(0)
                     Text("Manual").tag(1)
                }.fixedSize()
                Text("Automatic mode can slow things down")
                    .font(.system(size: 11.0))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct UserAccountsView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountsView()
    }
}
