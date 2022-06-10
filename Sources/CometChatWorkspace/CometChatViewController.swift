//
//  CometChatViewController.swift
//  
//
//  Created by Admin on 30/05/22.
//

import UIKit
import CometChatPro

open class CometChatViewController: UIViewController {

    @IBOutlet var button: UIButton!
    
    open override func loadView() {
        let bundle = Bundle(for: type(of: self))
        
        let loadedNib = Bundle.module.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        if let contentView = loadedNib?.first as? UIView  {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view  = contentView
        }
        print("bundle: \(bundle)")
    }
  
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
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
