//
//  AddPersonView.swift
//  RememberPerson
//
//  Created by Jules Lee on 1/18/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var name: String = ""
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.secondary)

                // display the image
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .onTapGesture {
                // select an image
                self.showingImagePicker = true
            }
            Form {
                TextField("Name of person", text: $name)
            }
        .navigationBarTitle("Add a Person")
            .navigationBarItems(trailing: Button(action: {
                self.save()
            }){
                Text("Save")
            })
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            guard let inputImage = self.inputImage else { return }
            self.inputImage = inputImage
            self.image = Image(uiImage: inputImage)
        }) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func save() {
        Person.saveImage(image: inputImage!)
        Person.savePerson(person: Person(id: UUID(), name: name, imageIdentifier: "\(inputImage!.accessibilityIdentifier ?? Date().description).jpg"))
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
