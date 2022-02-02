//
//  FontLoader.swift
//  Arc
//
//  Created by Michael L DePhillips on 2/2/22.
//  Copyright © 2022 HealthyMedium. All rights reserved.
//

import Foundation

public struct FontLoader {

    /// Configures all the UI of the package
    public static  func configurePackageUI() {
        loadPackageFonts()
    }

    public static func loadPackageFonts() {
        // All the filenames of your custom fonts here
        Roboto.robotoFonts.forEach{registerFont(fileName: $0)}
    }

    static func registerFont(fileName: String) {
    
        guard let pathForResourceString = Bundle.module.path(forResource: fileName, ofType: nil),
              let fontData = NSData(contentsOfFile: pathForResourceString),
              let dataProvider = CGDataProvider(data: fontData),
              let fontRef = CGFont(dataProvider) else {
            print("*** ERROR: ***")
            return
        }
    
        var errorRef: Unmanaged<CFError>? = nil
    
        if !CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) {
            print("*** ERROR: \(errorRef.debugDescription) ***")
        }
    }
}
