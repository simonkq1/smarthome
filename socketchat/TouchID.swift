//
//  TouchID.swift
//  socketchat
//
//  Created by admin on 2018/7/2.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import LocalAuthentication

let context = LAContext() // Touch ID 核心
var error:NSError? // 儲存錯誤訊息

class TouchID: NSObject {
    
    
   static private func check()->Bool{
        // 大於ios 9才檢查
        if #available(iOS 9.0, *) {
            let b:Bool = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            
            return b
            
        } else{
            return false
        }
        
    }
    
    static func verify(action: (()-> Void)? = nil ){
        if(TouchID.check()){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要驗證指紋來確認您的身份信息", reply: {success, error in
                
                if success {
                    // 驗證成功，登入
                    if action != nil {
                        action!()
                    }
                    
                }else {
                    
                    if let error = error as NSError? {
                        print(error)
                        
                        // 驗證失敗，印出錯誤訊息
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    
}
