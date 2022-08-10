//
//  SettingsView.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 04/04/22.
//

import SwiftUI
import StoreKit
/*
struct ProductRow: View {
    let storeProduct: StoreProduct
    let action: () -> Void
    var body: some View {
        HStack {
            ZStack {
                Image(storeProduct.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(9)
                    .opacity(storeProduct.isLocked ? 0.8 : 1)
                    .blur(radius: storeProduct.isLocked ? 3.0 : 0)
                    .padding()
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .opacity(storeProduct.isLocked ? 1 : 0)
            }
            VStack(alignment: .leading) {
                Text(storeProduct.title)
                    .font(.title)
                Text(storeProduct.description)
                    .font(.caption)
                Spacer()
                if let price = storeProduct.price, storeProduct.isLocked {
                    Button(action: action) {
                        Text(price)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing])
                            .padding([.top, .bottom], 5)
                            .cornerRadius(25)
                    }

                }
                
            }//: VSTACK
        }//: HSTACK
    }// BODY
}//: STRUCT VIEW
*/
struct ProductButton: View {
    let storeProduct: StoreProduct
    var body: some View {
        if (storeProduct.price != nil), storeProduct.isLocked {
            Text("Hazte Premium")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .cornerRadius(16)
        } else {
            Text("Ya eres premium".uppercased())
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(.green)
                .cornerRadius(16)
        }
    }
}
struct SettingsView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isPremium") var isPremium: Bool = false
    @AppStorage("sonidoToggle") var sonidoToggle: Bool = true
    @AppStorage("notificationToggle") var notificationToggle: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    // este es para la compra
    @EnvironmentObject private var storeViewModel: StoreViewModel
    
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - SECTION 1
                    
                    GroupBox(
                        label:
                            SettingsLabelView(labelText: "Listín", labelImage: "info.circle")
                    ) {
                        Divider().padding(.vertical, 4)
                        
                        HStack(alignment: .center, spacing: 10) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            Text("Listín es una apliación sencilla con la que puedes crear listas con precios; ya sea que quieras guardar listas de compras, listas de gastos, listas de presupuesto. Guarda cualquier lista que se te ocurra y te pueda ser útil tenerla a la mano. Para elimnar cualquier lista solo basta con darle swipe a la izquierda.")
                                .font(.footnote)
                        }
                    }
                    
                    // MARK: - SECTION 2
                    
                    GroupBox(
                        label: SettingsLabelView(labelText: "Hazte Premium", labelImage: "burst")
                    ) {
                        Divider().padding(.vertical, 4)
                        Text("Por un pago único de solo $49.00 MXN desbloqueas la app premium con la cual podrás crear todas las listas que tú quieras, así como agregar tantos items desees dentro de la lista.\nRecuerda que actualmente solo puedes crear hasta 5 listas y a cada una le puedes agregar solo 10 items.")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        ForEach (storeViewModel.allProducts, id: \.self) { prod in
                            Button {
                                if !prod.isLocked {
                                    print("Ya es premium")
                                } else {
                                    if let product = storeViewModel.product(for: prod.id){
                                        storeViewModel.purchaseProduct(product)
                                    }
                                }
                            } label: {
                                ProductButton(storeProduct: prod)
                            }

                        }
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                        Text("Si ya eras premium, da clic aquí y reestablece tu compra")
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        Button {
                            storeViewModel.restorePurchases()
                        } label: {
                            Text("Restaurar Compra")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(.blue)
                                .cornerRadius(16)
                        }

                        /*
                        Toggle(isOn: $isPremium){
                            if isPremium {
                                Text("Ya eres Premium".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Premium".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )*/
                        /*Text("Premium".uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            ).clipShape(RoundedRectangle(cornerRadius: 12))*/
                    }
                    
                    // MARK: - SECTION 3
                    
                    GroupBox(
                        label: SettingsLabelView(labelText: "Personaliza", labelImage: "slider.horizontal.3")
                    ) {
                        Divider().padding(.vertical, 4)
                        Toggle(isOn: $isDarkMode){
                            if isDarkMode {
                                Text("Modo Oscuro".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Modo Claro".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )
                        Toggle(isOn: $sonidoToggle){
                            if sonidoToggle {
                                Text("Sonido Encendido".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Sonido Apagado".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )
                        /*Toggle(isOn: $notificationToggle){
                            if notificationToggle {
                                Text("Notificaciones".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Notificaciones".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )*/
                    }
                    
                    // MARK: - SECTION 4
                    
                    GroupBox(
                        label: SettingsLabelView(labelText: "App", labelImage: "apps.iphone")
                    ) {
                        SettingsRowView(name: "Desarrollo", content: "Ing. Ceron")
                        
                        // Califícanos
                        VStack {
                            Divider().padding(.vertical, 4)
                            HStack {
                                Text("Califícanos").foregroundColor(.gray)
                                Spacer()
                                //Poner el link de mi app cuando la suba
                                    Link("App Store", destination: URL(string: "http://itunes.apple.com/us/app/id1635413931")!)
                                    Image(systemName: "star.square").foregroundColor(.blue)
                            }//: HStack
                        }//: VStack
                        //: Califícanos
                        
                        
                        // Contáctame
                        VStack {
                            Divider().padding(.vertical, 4)
                            Button(action: {
                                let whatsLink = "https://wa.me/525514862246"
                                let whatsUrl = URL(string: whatsLink)!
                                if UIApplication.shared.canOpenURL(whatsUrl)
                                {
                                    UIApplication.shared.open(whatsUrl)
                                } else {
                                   return
                                }
                            }, label: {
                                HStack{
                                Text("Contáctame")
                                    .foregroundColor(.gray)
                                    Spacer()
                                    Text("WhatsApp")
                                Image(systemName: "message")
                                    .foregroundColor(.green)
                                }
                        })
                        }//: Contáctame
                        
                        //SettingsRowView(name: "Website", linkLabel: "Satelapps.com", linkDestination: "swiftuimasterclass.com")
                        SettingsRowView(name: "SwiftUI", content: "3.0")
                        SettingsRowView(name: "Version", content: "1.3")
                    }
                    
                }//: VStack
                .onAppear() {
                    storeViewModel.loadStoredPurchases()
                }
                .navigationBarTitle(Text("Ajustes"), displayMode: .large)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                        }
                )
                .padding()
            }//: ScrollView
        }//: NavigationView
    }
}

//MARK: - Funcion de comprar
/* este codigo lo saque del curso de angela en udemy, pero es para uikit
 func buyPremiumListin() {
    
    if SKPaymentQueue.canMakePayments() {
        
        let paymentRequest = SKMutablePayment()
        paymentRequest.productIdentifier = productID
        SKPaymentQueue.default().add(paymentRequest)
        
    } else {
        
        print("el usuario no puede hacer compras")
        
    }
}
*/
//MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
