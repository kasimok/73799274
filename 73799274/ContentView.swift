//
//  ContentView.swift
//  73799274
//
//  Created by 0x67 on 2023-06-15.
//

import SwiftUI

struct ContentView: View {
  @State var field1: String
  @State var field2: String
  
  enum FocusedField {
    case field1, field2
  }
  
  @FocusState private var focusedField: FocusedField?
  
  var body: some View
  {
    
    VStack{
      TextEditor(text: $field1)
        .disableAutocorrection(false)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.system(size: 22, weight: .medium, design: .default))
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 1))
        .focused($focusedField, equals: .field1)
        .background(TabKeyEventHandling {
          // switch focus
          focusedField = .field2
        })
      
      
      TextEditor(text: $field2)
        .disableAutocorrection(false)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.system(size: 22, weight: .medium, design: .default))
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 1))
        .focused($focusedField, equals: .field2)
        .background(TabKeyEventHandling {
          // switch focus
          focusedField = .field1
        })
      
    }.onAppear {
      focusedField = .field1
    }
    
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(field1: "Foo", field2: "Bar")
  }
}


struct TabKeyEventHandling: NSViewRepresentable {
  
  var closure: (() -> Void)
  
  class KeyView: NSView {
    var closure: (() -> Void)?
    override var acceptsFirstResponder: Bool { true }
    override func keyDown(with event: NSEvent) {
      if event.keyCode == 48 // For tab
      {
        closure?()
      }
    }
  }
  
  func makeNSView(context: Context) -> NSView {
    let view = KeyView()
    view.closure = closure
    DispatchQueue.main.async { // wait till next event cycle
      view.window?.makeFirstResponder(view)
    }
    return view
  }
  
  func updateNSView(_ nsView: NSView, context: Context) {
  }
}
