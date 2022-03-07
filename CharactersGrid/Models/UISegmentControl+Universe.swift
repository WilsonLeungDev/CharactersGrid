//
//  UISegmentControl+Universe.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 2/3/2022.
//

import UIKit

extension UISegmentedControl {
    var selectedUniverse: Universe {
        switch selectedSegmentIndex {
            case 0: return .ff7r
            case 1: return .marvel
            case 2: return .dc
            case 3: return .starWars
            default: return .ff7r
        }
    }
}
