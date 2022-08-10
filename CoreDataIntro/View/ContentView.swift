//
//  ContentView.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // este es para acceder a la informacion de la compra, si ya lo compró o no.
    @EnvironmentObject private var storeViewModel: StoreViewModel
    
    
    @State private var companyName: String = ""
    @State private var showNewTaskItem: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("sonidoToggle") var sonidoToggle: Bool = true
    @AppStorage("isPremium") var isPremium: Bool = false
    @State private var isAlert: Bool = false
    @State private var id1: Int = 0
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Company.timestamp, ascending: true)],
        animation: .default)
    private var companies: FetchedResults<Company>
    
    
    @State var ajustes: Bool = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                VStack {
                    HStack {
                        Text("Mis Listas")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        Spacer()
                        Button {
                            ajustes = true
                            print("Ajustes")
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                        .padding([.trailing], 10)
                        Button(action: {
                            // TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            if sonidoToggle {
                                playSound(sound: "sound-tap", type: "mp3")
                            }else{
                                print("el sonidoToggle es \(sonidoToggle)")
                            }
                            
                            feedback.notificationOccurred(.success)
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" :  "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })
                        
                    }//: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    
                    Button(action: {
                        if let producto = storeViewModel.allProducts.first {
                            if !producto.isLocked {
                                showNewTaskItem = true
                            } else if companies.count < 5 {
                                showNewTaskItem = true
                            } else {
                                isAlert = true
                            }
                        }
                        if sonidoToggle {
                            playSound(sound: "sound-ding", type: "mp3")
                        }else{
                            print("el sonidoToggle es \(sonidoToggle)")
                        }
                        feedback.notificationOccurred(.success)
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Nueva Lista")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    
                    /*  AQUI ES LA PARTE DONDE SE DESPLIEGAN LAS LISTAS  */
                    List {
                        ForEach(companies) { company in
                            NavigationLink(destination: CompanyDetail(company: company)) {
                                    Text(company.name ?? "")
                                        .font(.system(.title2, design: .rounded))
                                        .fontWeight(.heavy)
                                        .lineLimit(1)
                                        .padding(.vertical, 12)
                                
                            }
                        }
                        .onDelete(perform: deleteCompany)
                    }//: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    
                    
                    /*  AQUI TERMINAN LAS LISTAS  */
                    
                }//: VSTACK
                .alert(isPresented: $isAlert) {
                    Alert(title: Text("Hazte Premium"), message: Text("Aún no eres Premium, recuerda que la versión gratuita solo te permite crear hasta 5 listas con 10 artículos. ¿Quieres ser Premium por tan solo $49.00 MXN?\nDirígete a los ajustes y hazte premium."), dismissButton: .default(Text("OK")))
                }
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                    .onTapGesture {
                        withAnimation() {
                            showNewTaskItem = false
                        }
                    }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            }//: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
                storeViewModel.loadStoredPurchases()
                storeViewModel.restorePurchases()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
            
        }//: NAVIGATIONVIEW
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $ajustes){
            SettingsView()
        }
    }
    
    
    private func addCompany() {
        withAnimation {
            let newCompany = Company(context: viewContext)
            newCompany.name = companyName
            newCompany.sumaDeArticulos = 0
            newCompany.listCount = 0
            newCompany.timestamp = Date()
            
            PersistenceController.shared.saveContext()
        }
    }
    
    private func deleteCompany(offsets: IndexSet) {
        withAnimation {
            offsets.map { companies[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext,
                                   PersistenceController.preview.container.viewContext)
    }
}
