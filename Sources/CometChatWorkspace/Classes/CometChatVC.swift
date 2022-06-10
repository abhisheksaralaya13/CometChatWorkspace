//
//  ViewController.swift
//  
//
//  Created by Pushpsen Airekar on 10/06/22.
//

import UIKit

public class CometChatVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    public override func loadView() {
        let bundle = Bundle(for: type(of: self))
        
        let loadedNib = Bundle.module.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        if let contentView = loadedNib?.first as? UIView  {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view  = contentView
        }
        print("bundle: \(bundle)")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
     
            image.image = UIImage(named: "messages-composer-send", in: Bundle.module, compatibleWith: nil)

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
