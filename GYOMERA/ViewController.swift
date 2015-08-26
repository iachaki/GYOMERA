//
//  ViewController.swift
//  GYOMERA
//
//  Created by ia on 2015/08/26.
//  Copyright (c) 2015年 Life is tech. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    //セッション
    var mySession : AVCaptureSession! //nillは基本❌”!”＊codeには書いてないけどstorybordにはあるよ！強め！
    //デバイス
    var myDevice : AVCaptureDevice!
    //画像のアウトプット
    var myImageOutput : AVCaptureStillImageOutput!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //セッションの生成
        mySession = AVCaptureSession()
        
        //デバイス一覧の取得
        let devices = AVCaptureDevice.devices()
        
        //バックカメラをmy deviceに格納
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        //バックカメラからVideoInputを取得
        let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput
        
        //セッションに追加
        mySession.addInput(videoInput)
        
        //出力先を生成
        myImageOutput = AVCaptureStillImageOutput()
        
        //セッションに追加
        mySession.addOutput(myImageOutput)
        
        //画像を表示するレイヤーを作成
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //viewに追加
        self.view.layer.addSublayer(myVideoLayer)
        
        //セッション開始
        mySession.startRunning()
        
        //UIボタンを作成
        let myButton = UIButton(frame: CGRectMake(0, 0, 81, 87))
        let myButtonImage = UIImage(named: "CameraButton.png" )
        myButton.setBackgroundImage(myButtonImage!, forState: .Normal)
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton", forControlEvents: .TouchUpInside)
        
        //UIボタンをViewに追加
        self.view.addSubview(myButton)
        
    }
    
      //ボタンイベント
       func onClickMyButton(sender: UIButton){
    
            //ビデオ出力に接続
            let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
    
            //接続から画像を取得
            self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: {(ImageDataBuffer, error) -> Void in
    
               //取得したImageDataのDataBufferをJpegに変換
                let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(ImageDataBuffer)
    
              //JpegからUIImageを作成
               let myImage : UIImage = UIImage(data: myImageData)!
    
                //アルバムに追加
               UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
    
    
            })
        }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
