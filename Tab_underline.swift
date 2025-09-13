//
//  Main.swift
//  apple
//
//  Created by Nicholas Conant-Hiley on 9/13/25.
//

import SwiftUI

struct Main: View {
    @State var currentTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab)  {
                View1().tag(0)
                View2().tag(1)
                View3().tag(2)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            
            TabBarView(currentTab: self.$currentTab)
        }
        
    }
}

#Preview {
    Main()
}

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Tab 1", "Tab 2,", "Tab 3"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                HStack(spacing: 24) {
                    ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)),
                            id: \.0,
                            content: {
                        index, name in
                        TabBarItem(currentTab: self.$currentTab,
                                   namespace: namespace.self,
                                   tabBarItemName: name,
                                   tab: index)
                        
                    })
                }
            }
        }
        .frame(height: 80)
        .edgesIgnoringSafeArea(.all)
        .padding(.top)
    }
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear
                        .frame(height: 2)
                }
                
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct View1: View {
    var body: some View {
        Text("View 1")
    }
}
struct View2: View {
    var body: some View {
        Text("View 2")
    }
}
struct View3: View {
    var body: some View {
        Text("View 3")
    }
}
