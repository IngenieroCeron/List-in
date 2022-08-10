//
//  ListRowView.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 26/07/22.
//

import SwiftUI

struct ListRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var employee: Employee
    var body: some View {
        Toggle(isOn: $employee.completion) {
            Text(employee.unwrappedName)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(employee.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
            Spacer()
            Text("$ \(employee.monto ?? "0")")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(employee.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
        } //: TOGGLE
        .toggleStyle(CheckboxStyle(employee: employee))
        .onReceive(employee.objectWillChange, perform: { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        })
    }
}
