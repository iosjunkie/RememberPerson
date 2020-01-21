//
//  ContentView.swift
//  RememberPerson
//
//  Created by Jules Lee on 1/18/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var people = [Person]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people, id: \.id) { (person) in
                    NavigationLink(destination: DetailView(person: person), label: {
                        if person.imageIdentifier.contains("bytes") {
                            Image(systemName: "person")
                        } else {
                            Person.retrieveImage(imageIdentifier: person.imageIdentifier)?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .padding(.trailing)
                        }
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            Text(person.location)
                                .font(.subheadline)
                        }
                        
                    })
                }
                .onDelete(perform: self.deleteItem)
            }
            .onAppear(perform: loadPeople)
            .navigationBarTitle("People To Remember")
            .navigationBarItems(leading: Button(action: {
                Person.deleteAll()
                self.loadPeople()
            }) {
                Text("Delete All")
                }, trailing: NavigationLink(destination: AddPersonView()) {
                Image(systemName: "plus")
            })
        }
    }
    
    func loadPeople() {
        people = Person.fetchPeople()
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        let index = indexSet.first!
        Person.deletePerson(people: people, person: people[index]) {
            self.people.remove(atOffsets: indexSet)
            loadPeople()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
