//
//  CheckboxStyle.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 26/07/22.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("sonidoToggle") var sonidoToggle: Bool = true
    @StateObject var employee: Employee
    //@StateObject var company: Company
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    feedback.notificationOccurred(.success)
                    
                    if sonidoToggle {
                        if configuration.isOn {
                            playSound(sound: "sound-rise", type: "mp3")
                        } else {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    
                    if configuration.isOn {
                        let resta = Int(employee.monto ?? "0") ?? 0
                        employee.company?.sumaDeArticulos -= Int32(resta)
                        print("la casilla esta palomeada")
                    } else {
                        let suma = Int(employee.monto ?? "0") ?? 0
                        employee.company?.sumaDeArticulos += Int32(suma)
                        print("la casilla esta apagada")
                    }
                }
            configuration.label
        } //: HSTACK
    }
}
