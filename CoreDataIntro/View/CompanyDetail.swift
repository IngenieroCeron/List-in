//
//  CompanyDetail.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//


/* para meterle la condicionante de no mas de 5 listas y 10 items, se me ocurre meter un if dentro del botón de agregar "+"
 if employee.count < 5 {
 addEmployee()
 }else {
 mandar una alerta que ha superado el limite de items que se haga premium
 }
 
 */
import SwiftUI
import StoreKit

struct CompanyDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // este es para acceder a la informacion de la compra, si ya lo compró o no.
    @EnvironmentObject private var storeViewModel: StoreViewModel
    
    
    @StateObject var company: Company
    @State private var employeeName: String = ""
    @State private var monto: String = ""
    @State private var sum = 0
    @State private var resta = 0
    @State private var isAlert: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isPremium") var isPremium: Bool = false
    private var isButtonDisabled: Bool {
        employeeName.isEmpty
    }
    @AppStorage("sonidoToggle") var sonidoToggle: Bool = true
    
    // ********* Fetch Request para sumar cada articulo agregado ************************************************************
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Employee.timestamp, ascending: true)],
        animation: .default)
    private var employeeees: FetchedResults<Employee>
    // ******** suma donde se suman los articulos
    //    private var sum: Int64 {
    //            employeeees.reduce(0) { $0 + $1.number }
    //    }
    // ************* termina codigo que agregué para sumar lo malo que se suma todo **********************************************************
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("1")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80, alignment: .top)
                //                    .scaledToFit()
                //                    .padding()
                VStack {
                    Text(company.name ?? "")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .padding()
                        .foregroundColor(.white)
                    HStack {
                        VStack(spacing: 16) {
                            TextField("Ingresa un Concepto", text: $employeeName)
                                .foregroundColor(.pink)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(12)
                                .background(
                                    isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                                )
                                .cornerRadius(10)
                            TextField("Ingresa un Monto", text: $monto)
                                .keyboardType(.numberPad)
                                .foregroundColor(.pink)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(12)
                                .background(
                                    isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                                )
                                .cornerRadius(10)
                        }//: HSTACK
                        Button(action: {
                            
                            if let producto = storeViewModel.allProducts.first {
                                if !producto.isLocked {
                                    addEmployee()
                                    print("Ya eres premium, ahora tienes \(company.listCount) articulos")
                                    
                                } else if company.listCount < 10 {
                                    addEmployee()
                                    print("No eres premium, ahora tienes \(employeeees.count) artículos")
                                    
                                } else {
                                    hideKeyboard()
                                    isAlert = true
                                    employeeName = ""
                                    monto = ""
                                }
                            }
                            if sonidoToggle {
                                playSound(sound: "sound-ding", type: "mp3")
                            }
                            feedback.notificationOccurred(.success)
                        }, label: {
                            Text("+")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
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
                        .padding(.horizontal, 15)
                        .padding(.vertical, 25)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.blue : Color.pink)
                        .cornerRadius(10)
                        
                    } //: HSTACK
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(
                        isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
                    )
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
                    .frame(maxWidth: 500)
                    .padding(.horizontal, 40)
                    
                    List {
                        ForEach(company.employeesArray) { employee in
                                ListRowView(employee: employee)
                        }.onDelete(perform: deleteEmployee)
                    }//: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    GroupBox {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Suma Total:")
                            Spacer()
                            Text("$ \(company.sumaDeArticulos)")
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal, 20)
                }//: VSTACK
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .alert(isPresented: $isAlert) {
                    Alert(title: Text("Hazte Premium"), message: Text("Aún no eres Premium, recuerda que la versión gratuita solo te permite crear hasta 5 listas con 10 artículos. ¿Quieres ser Premium por tan solo $49.00 MXN?\nDirígete a los ajustes y hazte premium."), dismissButton: .default(Text("OK")))
                }
                
                
            }//: ZSTACK
            .navigationTitle(company.name ?? "")
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
                storeViewModel.loadStoredPurchases()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
            
        }//: NAVIGATIONVIEW
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func addEmployee() {
        withAnimation {
            let newEmployee = Employee(context: viewContext)
            newEmployee.name = employeeName
            newEmployee.monto = monto
            newEmployee.timestamp = Date()
            sum = Int(monto) ?? 0
            company.sumaDeArticulos += Int32(sum)
            company.listCount += 1
            
            company.addToEmployees(newEmployee)
            PersistenceController.shared.saveContext()
            
            employeeName = ""
            monto = ""
            hideKeyboard()
        }
    }
    
    func deleteEmployee(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let employee = company.employeesArray[index]
                if !employee.completion {
                    resta = Int(employee.monto ?? "0") ?? 0
                    company.sumaDeArticulos -= Int32(resta)
                }
                company.listCount -= 1
                viewContext.delete(employee)
                
                PersistenceController.shared.saveContext()
            }
        }
    }
}


struct CompanyDetail_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCompany = Company(context: viewContext)
        newCompany.name = "Gastos"
        
        let employee1 = Employee(context: viewContext)
        employee1.name = "Cigarros"
        employee1.monto = "70"
        
        let employee2 = Employee(context: viewContext)
        employee2.name = "Alcohol"
        employee2.monto = "200"
        
        newCompany.addToEmployees(employee1)
        newCompany.addToEmployees(employee2)
        
        return Group {
            CompanyDetail(company: newCompany)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
