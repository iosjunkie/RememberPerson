//
//  DetailView.swift
//  RememberPerson
//
//  Created by Jules Lee on 1/18/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let person:Person
    var body: some View {
        GeometryReader { geometry in
            Text(self.person.name)
                .padding()
            Person.retrieveImage(imageIdentifier: self.person.imageIdentifier)?
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(person: Person.fetchPeople()[0])
    }
}
