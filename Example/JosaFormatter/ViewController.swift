//
//  ViewController.swift
//  JosaFormatter
//
//  Created by b1uec0in on 05/30/2017.
//  Copyright (c) 2017 b1uec0in. All rights reserved.
//

import UIKit
import JosaFormatter

class ViewController: UIViewController {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOkButtonTouchUp(_ sender: Any) {
        var message = "닉네임을 입력하세요."
        
        if let text = nickNameTextField.text {
            if text.length > 0 {
                message = KoreanUtils.format("'%@'를 입력했습니다.", text)
            }
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

