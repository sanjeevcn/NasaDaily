//
//  CustomTextField.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI
import Combine

struct DateTextField: View {
    @Binding var data: Field
    
    let fieldLimit: Int
    @State var date = Date()
    
    init(data: Binding<Field>, limit: Int = 10) {
        self._data = data
        self.fieldLimit = limit
    }
    
    //Private
    @State private var isFieldValid : Bool   = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                textfield()
                    .onChange(of: Just(data.value), perform: { _ in
                        switch data.type {
                        case .date:
                            limitText(10)
                        default:
                            limitText(50)
                        }
                    })
                datepicker()
            }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Text(self.isFieldValid ? data.name : "Please enter valid \(data.name)")
                .font(.system(.footnote))
                .padding(.horizontal, 10)
                .background((self.isFieldValid ? Color.accentColor : Color.red).cornerRadius(5))
                .offset(x: 16, y: -8)
                .foregroundColor(Color.white)
                .animation(.spring(), value: self.isFieldValid)
        }
    }
    
    func textfield() -> some View {
        TextField("YYYY-MM-DD", text: $data.value) { (isChanged) in
            if !isChanged {
                guard (data.type == .date) else { return }
                isFieldValid = data.value.isValidDate
                date = formattedDate(from: data.value.removeSpaces)
                data.value = data.value.removeSpaces
            }
        } onCommit: {
            guard (data.type == .date) else { return }
            data.value = data.value.removeSpaces
        }
        .keyboardType((data.type == .date) ? .numbersAndPunctuation : .alphabet)
        .autocapitalization(.none)
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
    
    //MARK: Text length in limits
    func limitText(_ upper: Int) {
        if data.value.count > upper {
            data.value = String(data.value.removeSpaces.prefix(upper))
        }
    }
    
    func datepicker() -> some View {
        DatePicker(selection: Binding(
            get: { date },
            set: { date = $0; data.value = DateFormatter.formate.string(from: $0) }
        ), in: ...Date(), displayedComponents: .date)
        {
            HStack {
                Text(data.value.isEmpty ? "Select \(data.name): " : data.name)
                    .font(.headline)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .opacity(0.7)
                Image(systemName: "chevron.down")
                    .padding(.vertical, 12)
                    .opacity(0.7)
            }
        }.datePickerStyle(.compact)
            .padding(.trailing, 10)
            .id(data.id)
            .labelsHidden()
    }
    
    func formattedDate(from dateString: String) -> Date {
        guard !dateString.isEmpty else { return date }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date()
    }
}

struct TextFieldModifier: ViewModifier {
    let fontSize: CGFloat
    let backgroundColor: Color
    let textColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: fontSize))
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
            .foregroundColor(textColor)
            .padding()
    }
}
