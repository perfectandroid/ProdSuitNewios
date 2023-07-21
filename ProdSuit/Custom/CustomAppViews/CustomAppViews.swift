//
//  CustomAppViews.swift
//  ProdSuit
//
//  Created by MacBook on 17/03/23.
//

import Foundation
import UIKit

@IBDesignable
final class BackButtonCC:UIButton{
    
    @IBInspectable var titleText:String?{
        didSet{
            self.setTitle(titleText, for: .normal)
        }
    }
    
    @IBInspectable var titleColor:UIColor=AppColor.Shared.colorWhite{
        didSet{
            
            
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    

    @IBInspectable weak var images:UIImage?{
        didSet{
        
            
            self.setImage(images, for: UIControl.State.normal)
            
            
        }
    }

    override func awakeFromNib() {
        self.imageView?.layer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6)
    }
    
}

@IBDesignable
final class RoundCornerView:UIView{
    
    @IBInspectable var view_radius:CGFloat=5{
        didSet{
            
            self.setCornerRadius(size: view_radius)
        }
    }
    
   
    
    override init(frame: CGRect){
            super.init(frame: frame)
        
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
 }
}


@IBDesignable
final class BorderView:UIView{
    @IBInspectable var borderColor: UIColor? {
            set {
                layer.borderColor = newValue?.cgColor
            }
            get {
                guard let color = layer.borderColor else {
                    return nil
                }
                return UIColor(cgColor: color)
            }
        }
    

      @IBInspectable var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }
    
    @IBInspectable var cornerRadius: CGFloat=0 {
        didSet{
            self.setCornerRadius(size: cornerRadius)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
 }
}




@IBDesignable
final class LeftViewTextField:UITextField{
    
    
    @IBInspectable var image:UIImage?{
        didSet{
            leftImgView.image = image
        }
    }
    
    @IBInspectable var topDefault:Bool=false
    
    lazy var leftImgView:UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AppColor.Shared.colorPrimary
        //imageView.backgroundColor = AppColor.Shared.purple_500
        return imageView
    }()
    
    lazy var leftview:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        self.leftView = leftview
        self.leftViewMode = .always
        self.keyboardType = .numberPad
        self.tintColor = AppColor.Shared.greyTitle
        self.textColor = AppColor.Shared.greyTitle
        self.font = AppFonts.Shared.Regular.withSize(15)
        setup()
    }
    
    override init(frame: CGRect){
            super.init(frame: frame)
            
        
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
 }
    
    func setup(){
        
        leftview.addSubview(leftImgView)
        
        
        leftview.backgroundColor = UIColor.clear
        var leftConstraint = [NSLayoutConstraint]()
        leftConstraint.append(leftview.leadingAnchor.constraint(equalTo: self.leftView!.leadingAnchor, constant: 0))
        
        leftConstraint.append(leftview.topAnchor.constraint(equalTo: self.leftView!.topAnchor, constant: 0))
        
        leftConstraint.append(leftview.bottomAnchor.constraint(equalTo: self.leftView!.bottomAnchor, constant: 0))
        
        leftConstraint.append(leftview.widthAnchor.constraint(equalToConstant: 40))
        
        NSLayoutConstraint.activate(leftConstraint)
        
        var imageConstraint = [NSLayoutConstraint]()
        imageConstraint.append(leftImgView.centerXAnchor.constraint(equalTo: leftview.centerXAnchor, constant: 0))
//        imageConstraint.append(leftImgView.centerYAnchor.constraint(equalTo: leftview.centerYAnchor, constant: 0))
        imageConstraint.append(leftImgView.topAnchor.constraint(equalTo: leftview.topAnchor, constant: topDefault == false ? 5.75 :  10.5))
        imageConstraint.append(leftImgView.widthAnchor.constraint(equalToConstant: 24))
        imageConstraint.append(leftImgView.heightAnchor.constraint(equalToConstant: 24))
        
        NSLayoutConstraint.activate(imageConstraint)
        
        
    }
}


class ContactusTitleLabel:UILabel{
    override func awakeFromNib() {
        self.textColor = AppColor.Shared.colorWhite
        self.font = AppFonts.Shared.Medium.withSize(20)
    }
}

class AboutusTitleLabel:UILabel{
    override func awakeFromNib() {
        self.textColor = AppColor.Shared.colorWhite
        self.font = AppFonts.Shared.Medium.withSize(20)
    }
}

class AboutTechnologyLabel:UILabel{
    override func awakeFromNib() {
        self.textColor = AppColor.Shared.coloBlack
        self.font = AppFonts.Shared.Bold.withSize(16)
    }
}

class AboutDescriptionLabel:UILabel{
    override func awakeFromNib() {
        self.textColor = AppColor.Shared.greyText
        self.font = AppFonts.Shared.Regular.withSize(15)
    }
}


class LRSideImageViewTF:UITextField{
    
    @IBInspectable var leftImage:UIImage?{
        didSet{
            leftSideImageView.image = leftImage
        }
    }
    
    @IBInspectable var rightImage:UIImage?{
        didSet{
            rightSideImageView.image = rightImage
        }
    }
    
    lazy var leftSideImageView:UIImageView={
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imgView.translatesAutoresizingMaskIntoConstraints = true
       
        imgView.tintColor = AppColor.Shared.coloBlack
        return imgView
    }()
    
    lazy var rightSideImageView:UIImageView={
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imgView.translatesAutoresizingMaskIntoConstraints = true
        imgView.image = rightDownImage
        imgView.tintColor = AppColor.Shared.coloBlack
        return imgView
    }()
    
    lazy var leftSideView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        //containerView.backgroundColor = AppColor.Shared.purple_500
        
        return containerView
    }()
    
    lazy var rightSideView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        //containerView.backgroundColor = AppColor.Shared.purple_500
        
        return containerView
    }()
    
    override func awakeFromNib() {
        self.setBorder(width: 0.6, borderColor: AppColor.Shared.coloBlack)
        self.setCornerRadius(size: 5)
        self.leftView = leftSideView
        self.leftViewMode = .always
        self.rightView = rightSideView
        self.rightViewMode = .always
        self.setTextColor(AppColor.Shared.coloBlack)
        leftSideView.addSubview(leftSideImageView)
        leftSideImageView.center = leftSideView.center
        
        rightSideView.addSubview(rightSideImageView)
        rightSideImageView.center = rightSideView.center
       
        
        self.setFontSize(14, font: .regular)
      
        self.tintColor = UIColor.clear
    }
    
    
}


class LSideImageViewTF:UITextField{
    
    @IBInspectable var leftImage:UIImage?{
        didSet{
            leftSideImageView.image = leftImage
        }
    }
    
   
    
    lazy var leftSideImageView:UIImageView={
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imgView.translatesAutoresizingMaskIntoConstraints = true
       
        imgView.tintColor = AppColor.Shared.coloBlack
        return imgView
    }()
    
   
    
    lazy var leftSideView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        //containerView.backgroundColor = AppColor.Shared.purple_500
        
        return containerView
    }()
    
   
    
    override func awakeFromNib() {
        self.setBorder(width: 0.6, borderColor: AppColor.Shared.coloBlack)
        self.setCornerRadius(size: 5)
        self.leftView = leftSideView
        self.leftViewMode = .always
       
        self.setTextColor(AppColor.Shared.coloBlack)
        leftSideView.addSubview(leftSideImageView)
        leftSideImageView.center = leftSideView.center
        
     
       
        
        self.setFontSize(14, font: .regular)
      
        
    }
    
    
}

class CircleCornerView:UIView{
    override func layoutSubviews() {
           super.layoutSubviews()

           let radius: CGFloat = self.bounds.size.width / 2.0

           self.layer.cornerRadius = radius
       }
}

class PunchPopUpTitleLbl:UILabel{
    override func awakeFromNib() {
        self.font = AppFont.semiBold.size(15)
        self.textAlignment = .center
        self.setTextColor(AppColor.Shared.coloBlack)
    }
}

class PunchPopUpTextLbl:UILabel{
    override func awakeFromNib() {
        self.font = AppFont.regular.size(14)
        self.setTextColor(AppColor.Shared.coloBlack)
    }
}

class PunchPopUpYesBtn:UIButton{
    override func awakeFromNib() {
        self.titleLabel?.setFontSize(14, font: AppFont.medium, autoScale: true)
        self.titleLabel?.setTextColor(AppColor.Shared.colorWhite)
        self.setCornerRadius(size: 5)
        self.setBGColor(color: AppColor.Shared.punchYesColor)
       
    }
}


class PunchPopUpNoBtn:UIButton{
    override func awakeFromNib() {
        self.titleLabel?.setFontSize(14, font: AppFont.medium, autoScale: true)
        self.titleLabel?.setTextColor(AppColor.Shared.colorWhite)
        self.setCornerRadius(size: 5)
        self.setBGColor(color: AppColor.Shared.colorPrimary)
       
    }
}

class PunchCancelBtn:UIButton{
    override func awakeFromNib() {
        self.titleLabel?.setFontSize(14, font: AppFont.medium, autoScale: true)
        self.titleLabel?.setTextColor(AppColor.Shared.coloBlack)
        
        self.setBGColor(color: AppColor.Shared.D6D6D6)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shaplayer = CAShapeLayer()
         shaplayer.path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.bottomLeft, cornerRadii: CGSize(width: 8, height: 8)).cgPath
             self.layer.mask = shaplayer
    }
}


class PunchConfirmBtn:UIButton{
    override func awakeFromNib() {
        self.titleLabel?.setFontSize(14, font: AppFont.medium, autoScale: true)
        self.titleLabel?.setTextColor(AppColor.Shared.colorWhite)
       
        

        self.setBGColor(color: AppColor.Shared.colorPrimary)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shaplayer = CAShapeLayer()
         shaplayer.path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.bottomRight, cornerRadii: CGSize(width: 8, height: 8)).cgPath
             self.layer.mask = shaplayer
    }
}


class PunchTitleLbl:UILabel{
    override func awakeFromNib() {
        self.font = AppFont.semiBold.size(13)
        self.setTextColor(AppColor.Shared.coloBlack)
    }
}

class PunchTextLbl:UILabel{
    var setColor:UIColor = AppColor.Shared.greyText{
        didSet{
            self.setTextColor(setColor)
        }
    }
    override func awakeFromNib() {
        self.font = AppFont.regular.size(12)
        self.setTextColor(setColor)
        
    }
}

class PunchNameLbl:UILabel{
    override func awakeFromNib() {
        self.font = AppFont.medium.size(16)
        self.setTextColor(AppColor.Shared.coloBlack)
    }
}

class PunchUserImageView:UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
        self.setBorder(width: 1.5, borderColor: AppColor.Shared.redDark)
    }
}
