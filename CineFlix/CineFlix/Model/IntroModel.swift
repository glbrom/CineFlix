//
//  Intro.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import SwiftUI

// MARK: - Intro Model and Data
struct Intro: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var description: String
}

let nameApp = "Cineflix"

let intros: [Intro] = [
    Intro(image: "1", title: "Welcome to \(nameApp)", description: "Check the movie and TV-shows, watch trailers, read reviews"),
    Intro(image: "2", title: "Are you ready?", description: "Let's dive into the world of cinema with \(nameApp)"),
    Intro(image: "3", title: "Call friends", description: "Get the best an exceptional movie experience together"),
    Intro(image: "4", title: "Let's go!", description: "Don't forget to bring delicious")
]
