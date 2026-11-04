//
//  BundleLocator.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

extension Bundle {
    public static func resourceBundle(named name: String, in bundle: Bundle) -> Bundle? {
        guard let url = bundle.url(forResource: name, withExtension: "bundle") else { return nil }

        return Bundle(url: url)
    }

    public func localizedBundle(for locale: Locale) -> Bundle {
        let preferred = Bundle.preferredLocalizations(
            from: localizations,
            forPreferences: [locale.identifier]
        )
        guard let language = preferred.first,
            let path = path(forResource: language, ofType: "lproj"),
            let localized = Bundle(path: path)
        else { return self }

        return localized
    }
}
