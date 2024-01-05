//
//  Recents.swift
//  Expense Tracker
//
//  Created by Kirills Galenko on 30/12/2023.
//

import SwiftUI

struct Recents: View {
    // User properties
    @AppStorage("userName") private var userName: String = ""
    // View Properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    
    @State private var selectedCategory: Category = .expense
    
    @Namespace private var animation
    
    var body: some View {
        GeometryReader{
            // for animations
            let size = $0.size
            
            NavigationStack{
                ScrollView(.vertical){
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                        Section{
                            // Date filter button
                            Button(action: {}, label: {
                                Text("\(format(date: startDate, format: "dd - MMM yy")) to \(format(date: endDate, format: "dd - MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                            .hSpacing(.leading)
                            
                            // Card View
                            CardView(income: 2039, expense: 4381)
                            
                            // Custom Segmented Control
                            CustomSegmentedControl()
                                .padding(.bottom, 10)
                            
                            ForEach(sampleTransactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                TransactionCardView(transaction: transaction)
                            }
                        } header:{
                            HeaderView(size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
            }
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size: CGSize ) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5, content: {
                 Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(HeaderScale(size,proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            NavigationLink {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle )
            }
        }
        
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background{
            VStack(spacing: 0, content: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            })
            .visualEffect { content, geometryProxy in
                content
                    .opacity(HeaderBGOpacity(geometryProxy))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        }
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background{
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                     .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    func HeaderBGOpacity(_ proxy: GeometryProxy) -> CGFloat{
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func HeaderScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.3
        
        return 1 + scale
    }
}

#Preview {
    ContentView()
}
