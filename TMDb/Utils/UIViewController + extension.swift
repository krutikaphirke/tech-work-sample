//
//  UIViewController + extension.swift
//  TMDb
//
//  Created by Krutika on 2022-05-09.
//

import Foundation
import UIKit
extension UIViewController {
    class var identifier: String {
        return String(describing: self)
    }
    func getDetailVC(_ id : Int) -> DetailViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard .instantiateViewController(identifier: DetailViewController.identifier) { coder -> DetailViewController? in
            DetailViewController(coder: coder, id: id)
        }
        return vc
    }
}
