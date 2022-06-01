//
//  CometChatViewController.swift
//  
//
//  Created by Admin on 30/05/22.
//

import UIKit

open class CometChatViewController: UIViewController {

    @IBOutlet var button: UIButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.titleLabel?.text = "Button"
        button.tintColor = .blue
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
