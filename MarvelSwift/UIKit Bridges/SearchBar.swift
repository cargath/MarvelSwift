//
//  SearchBar.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 21.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        var searchBar: SearchBar

        init(_ searchBar: SearchBar) {
            self.searchBar = searchBar
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchBar.text = searchText
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

}
