//
//  Person.swift
//  RememberPerson
//
//  Created by Jules Lee on 1/18/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct Person: Identifiable, Comparable, Codable {
    let id: UUID
    let name: String
//    let image: UIImage
//    let wrappedImage: Image
    var imageIdentifier: String
    
    static func retrieveImage(imageIdentifier: String) -> Image? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var image: Image? = nil
        let filename = paths[0].appendingPathComponent(imageIdentifier)
        if (FileManager.default.fileExists(atPath: filename.path)) {
            do {
                let data = try Data(contentsOf: filename)
                image = Image(uiImage: UIImage(data: data)!)
                return image!
            } catch {
                print("Unable to load saved image.")
            }
        }
        
        return image
    }
    
    static func saveImage(image: UIImage) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(image.accessibilityIdentifier ?? Date().description).jpg")
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: path, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
    }
    
    static func fetchPeople() -> [Person] {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var people = [Person]()
        let filename = paths[0].appendingPathComponent("SavedPeople")
        do {
            let data = try Data(contentsOf: filename)
            people = try JSONDecoder().decode([Person].self, from: data)
            print(people)
        } catch {
            print("Unable to load saved data.")
        }
        
        return people
    }
    
    static func savePerson(person: Person) {
        var people = fetchPeople()
        people.append(person)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let filename = paths[0].appendingPathComponent("SavedPeople")
            let data = try JSONEncoder().encode(people)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    static func deletePerson(people: [Person], person: Person, completion: () -> Void) {
        var people = people
        people.remove(at: people.firstIndex{$0.id == person.id}!)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let filename = paths[0].appendingPathComponent("SavedPeople")
            let data = try JSONEncoder().encode(people)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            completion()
        } catch {
            print("Unable to delete data")
        }
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }
}
