//
//  ChooseTagViewController.swift
//  GYOMERA
//
//  Created by ia on 2015/08/26.
//  Copyright (c) 2015年 Life is tech. All rights reserved.
//

import UIKit

class ChooseTagViewController: UIViewController {
    
    @IBOutlet var imageView : UIImageView!
    
    var tagImage:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageViewにtagImageを表示する
        imageView.image = tagImage

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
