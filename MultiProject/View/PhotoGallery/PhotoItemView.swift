//
//  PhotoItemView.swift
//  NavigationEffect
//
//  Created by window1 on 7/18/24.
//

import SwiftUI

struct PhotoItemView: View {
    @ObservedObject var model: PhotoViewModel
    @Binding var showDetailView: Bool
    @Binding var seletedItem: DataModel
    @Binding var position: CGSize
    
    @State private var isHDrag = false
    @State private var isVDrag = false
    
    var body: some View {
        ZStack {
            Color
                .white
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .opacity(!showDetailView ? 0 : 1 - abs(Double(position.height) / 800))
            HStack {
                Image(seletedItem.value ?? "")
                    .resizable()
                    .scaledToFit()
                    .zIndex(2)
                    .offset(position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                checkHorizontalAndVerticalMove(value)
                            }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.1, dampingFraction: 1.0)){
                                    checkGestureEndMove(value)
                                }
                            }
                    )
            }
        }
        .navigationTitle("\(String(seletedItem.value ?? ""))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showDetailView.toggle()
                } label: {
                    Text("보관함")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.blue)
                        .frame(width: 41, height: 41)
                }
            }
        }
    }
    
    func checkHorizontalAndVerticalMove(_ value: DragGesture.Value) {
        if !isHDrag && !isVDrag {
            if abs(value.translation.width) > abs(value.translation.height) {
                isHDrag = true
            } else {
                isVDrag = true
            }
        }
        if isHDrag {
            self.position.width = value.translation.width
        } else if isVDrag {
            self.position.height = value.translation.height
        }
    }
    
    func checkGestureEndMove(_ value: DragGesture.Value) {
        if isHDrag {
            changeSelectedItem(width: position.width, index: seletedItem.index ?? 0)
            self.position = .zero
        }
        else if isVDrag {
            if abs(self.position.height) > 200 {
                showDetailView.toggle()
            } else {
                self.position = .zero
            }
        }
        isHDrag = false
        isVDrag = false
    }
    
    
    
    func changeSelectedItem(width: Double, index: Int) {
        
        let threshold: Double = 100
        if width > threshold && index != 0 {
            seletedItem.index = index - 1
        }
        else if width < -threshold && index != model.data.endIndex - 1 {
            seletedItem.index = index + 1
        }
        seletedItem = (model.data[seletedItem.index ?? 0])
    }
}


#Preview {
    PhotoItemView(model: .init(), showDetailView: .constant(false), seletedItem: .constant(.init(value: "bobcat", index: 0)), position: .constant(CGSize(width: 0, height: 0)))
}


