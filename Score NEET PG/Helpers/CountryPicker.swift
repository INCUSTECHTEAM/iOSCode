//
//  CountryPicker.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI
import CountryPicker

struct CountryPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = CountryPickerViewController

    let countryPicker = CountryPickerViewController()

    @Binding var country: Country?

    func makeUIViewController(context: Context) -> CountryPickerViewController {
        countryPicker.selectedCountry = "IN"
        countryPicker.delegate = context.coordinator
        return countryPicker
    }

    func updateUIViewController(_ uiViewController: CountryPickerViewController, context: Context) {
        //
        
        let configMaker = Config(
             countryNameTextColor: .darkText,
             countryNameTextFont: UIFont.systemFont(ofSize: 16),
             selectedCountryCodeBackgroundColor: .orange,
             closeButtonTextColor: .orange
         )

        CountryManager.shared.config = configMaker
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, CountryPickerDelegate {
        var parent: CountryPicker
        init(_ parent: CountryPicker) {
            self.parent = parent
        }
        func countryPicker(didSelect country: Country) {
            parent.country = country
        }
    }
}
