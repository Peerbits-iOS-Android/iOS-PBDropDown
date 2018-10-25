//
//  ViewController.swift
//  PBDropDown
//
//  Created by Tej on 25/10/18.
//  Copyright © 2018 Peerbits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnDropdown(_ sender: UIButton)
    {
        let dropdown = PBDropdown()
        dropdown.dropDownDelegate = self
        dropdown.show(vc : self, anchorView: sender, sourceArray: ["one","two"], direction: .Up, isSearch: true)
    }
}
extension ViewController : PBDropdownDelegate {
    func didSelectDropDown(_ index: Int, _ data: Any) {
        print(index)
        print(data)
    }
}
