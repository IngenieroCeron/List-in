//
//  NewTaskItemView.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @State private var companyName: String = ""
    @Binding var isShowing: Bool
    @AppStorage("sonidoToggle") var sonidoToggle: Bool = true
    
    private var isButtonDisabled: Bool {
        companyName.isEmpty
    }
    
    // MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newCompany = Company(context: viewContext)
            newCompany.name = companyName
            PersistenceController.shared.saveContext()
            
            companyName = ""
            hideKeyboard()
            isShowing = false
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    TextField("Nombre de tu lista", text: $companyName)
                        .foregroundColor(.pink)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding()
                        .background(
                            isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                        )
                        .cornerRadius(10)
                    
                    Button(action: {
                        
                        addItem()
                        
                        if sonidoToggle {
                            playSound(sound: "sound-ding", type: "mp3")
                        }else{
                            print("el sonidoToggle es \(sonidoToggle)")
                        }
                        
                        feedback.notificationOccurred(.success)
                        
                    }, label: {
                        Spacer()
                        Text("AGREGAR")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                    })
                    .disabled(isButtonDisabled)
                    .onTapGesture {
                        if isButtonDisabled {
                            if sonidoToggle {
                                playSound(sound: "sound-tap", type: "mp3")
                            }else{
                                print("el sonidoToggle es \(sonidoToggle)")
                            }
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(isButtonDisabled ? Color.blue : Color.pink)
                    .cornerRadius(10)
                } //: VSTACK
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(
                    isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
                )
                .cornerRadius(16)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
                .frame(maxWidth: 640)
                
                Spacer()
                
            } //: VSTACK
            .padding()
        
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .previewDevice("iPhone 12 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
