//
//  inputView.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class InputView: UIView {

    var placeholder : String!
    
    var img_check : UIImageView!
    var tf_field : FloatLabelTextField!
    
    override func loadView()
    {

        tf_field = FloatLabelTextField(frame: CGRectMake(UIView.factorScreenWidth(45.0) , UIView.factorScreenHeight(20) , UIView.factorScreenWidth(330)  , UIView.factorScreenHeight(54)))
        fld.placeholder = self.placeholder
        tf_field.font = UIFont(name: Font_Dosis_Regular, size: 16)
        tf_field.titleTextColour = Color_Gray
        tf_field.titleActiveTextColour = Color_Gray
        tf_field.textColor = Color_Blue
        self.addSubview(fld)

        let lineView = UIView(frame:  CGRectMake(UIView.factorScreenWidth(45.0) , (self.height - 1) , UIView.factorScreenWidth(330)  , 1))
        lineView.backgroundColor = Color_Gray
        self.addSubview(lineView)

        img_check = UIImageView(frame: CGRectMake(UIView.factorScreenWidth(345.0) , self.height - 21 , 20, 20))
        img_check.image = UIImage(named: "acceptBtn")
        self.addSubview(img_check)

        }
    

}