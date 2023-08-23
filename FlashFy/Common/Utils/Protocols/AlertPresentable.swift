//
//  AlertPresentable.swift
//  FlashFy
//
//  Created by Yasin Cetin on 21.08.2023.
//

import Foundation

import UIKit

protocol AlertPresentable {
    func presentAlert(_ message:String)
}

extension AlertPresentable where Self: UIViewController {
    
    func presentAlert(_ message:String) {
        let allert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
}
