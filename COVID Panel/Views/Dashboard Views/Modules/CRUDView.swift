//
//  CRUDView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/22/20.
//

import SwiftUI
import RealmSwift

struct CRUDView: View {
    
    @State var results: Results<CovidDataInRealm> = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order")
    @State var searchText: String = ""
    @State var searchedCovidData: CovidDataModel? = nil
    
    var covidDataManager: CovidDataGarbber {
        CovidDataGarbber(covidData: $searchedCovidData)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(placeholder: "Search for location", text: $searchText, onTap: { location in
//                    covidDataManager.updateView(addr_string: location, mapGoTo: {_  in })
                })
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                if let safe_covidData = searchedCovidData {
                    NavigationLink(
                        destination: PlaceDetailView(covidData: safe_covidData)
                            .navigationTitle(safe_covidData.name!),
                        label: {
                            PlaceCardView(covidData: safe_covidData)
                                .placeCardStyle()
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                    
                    Button(action: {
                        addCovidDataToRealm(covidDataModel: safe_covidData)
                        searchedCovidData = nil
                        searchText = ""
                    }, label: {
                        Label(
                            title: { Text("Add") },
                            icon: { Image(systemName: "plus.app") }
                        )
                    })
                    .padding(.bottom, 10)
                    .disabled(try! Realm().objects(CovidDataInRealm.self).filter(safe_covidData.getQueryForRealm()).count == 0 ? false : true)

                }
                
                List {
                    ForEach((0..<results.count), id:\.self) { idx in
                        Text(results[idx].name)
                    }
                    .onDelete(perform: deleteInRealm)
                    .onMove(perform: moveInRealm)
                }
                .navigationBarItems(trailing: EditButton())
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Saved Location")
            //            .background(Color(UIColor.systemGray6))
        }
    }
}

struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}


extension CRUDView {
    
    func moveInRealm(from source: IndexSet, to destinationRow: Int) {
        if let sourceRow = source.first {
            let sourceObject = results[sourceRow]
            let realm = try! Realm()
            do {
                try realm.write {
                    if sourceRow < destinationRow {
                        for index in (sourceRow+1)..<destinationRow {
                            let result = results[index]
                            result.order -= 1
                        }
                        sourceObject.order = destinationRow - 1
                    } else {
                        for index in (destinationRow..<sourceRow).reversed() {
                            let result = results[index]
                            result.order += 1
                        }
                        sourceObject.order = destinationRow
                    }
                    
                    
                }
            } catch {
                print("Error moving card \(error)")
            }
        }
        results = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order")
    }
    
    func deleteInRealm(at offsets: IndexSet) {
        if let first = offsets.first {
            let objectTodelete = results[first]
            let realm = try! Realm()
            do {
                try realm.write {
                    if first + 1 < results.count {
                        for index in (first+1)..<results.count {
                            let result = results[index]
                            result.order -= 1
                        }
                    }
                    realm.delete(objectTodelete)
                }
            } catch {
                print("Error deleting card \(error)")
            }
        }
        results = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order")
    }
    
    func addCovidDataToRealm(covidDataModel: CovidDataModel) {
        let newOrder = results.count
        let covidDataInRealm = CovidDataInRealm(covidDataModel: covidDataModel, order: newOrder)
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(covidDataInRealm)
            }
        } catch {
            print("Error saving card \(error)")
        }
    }
}
