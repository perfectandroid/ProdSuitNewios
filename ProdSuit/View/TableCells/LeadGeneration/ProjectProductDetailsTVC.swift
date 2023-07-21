//
//  ProjectProductDetailsTVC.swift
//  ProdSuit
//
//  Created by MacBook on 05/04/23.
//

import UIKit

protocol ProductModelDelegate:AnyObject{
    func getProductModel(model:String)
}

protocol ProductEnquiryDelegate:AnyObject{
    func getEnquiryText(text:String)
}

protocol ProductOfferPriceDelegate:AnyObject{
    func getOfferPrice(value:String)
}

protocol QuantityDelegate:AnyObject{
    func maxQuantity(cell:ProjectProductDetailsTVC,qty:String)
}

class ProjectProductDetailsTVC: UITableViewCell{
    
    fileprivate func enableDisableFollowUpView(isEnabled:Bool) {
        UIView.animate(withDuration: 0.25, animations: {
//            self.followUpView.isHidden = true
//            self.followUpView.subviews.map{ $0.isHidden = true }
            self.actionTextField.isHidden = isEnabled
            self.actionTypeTextField.isHidden = isEnabled
            self.dateTextField.isHidden = isEnabled
            self.nameTextField.isHidden = isEnabled
            self.dateTextField.dateTodayOnwards = true
            
            UIView.animate(withDuration: 0.1, delay: 0) {
                
                self.productStackView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
           
        })
    }
    
    
    @IBOutlet weak var expectedDateTF: LeadExpaectedDateTF!
        
    
    var hasFollowUp:Bool?{
        didSet{
            if hasFollowUp == true{
                
                enableDisableFollowUpView(isEnabled: false)
                
            }else{
                
                enableDisableFollowUpView(isEnabled: true)
                
            }
        }
    }
    
    var isZeroProject:NSNumber = 0{
        didSet{
            if isZeroProject == 0{
                
                self.actionTextField.isHidden = true
                self.subCategoryQtyTextField.isHidden = false
                self.subCategoryTextField.customPlaceholder(color: AppColor.Shared.greyText, text: "Product")
                self.subCategoryTextField.rightView = self.subCategoryTextField.rightSideImageView
                self.subCategoryTextField.rightViewMode = .always
                self.subCategoryTextField.text = ""
                self.subCategoryQtyTextField.keyboardType = .numberPad
                self.subCategoryQtyTextField.addDonButton()
                self.subCategoryTextField.resignFirstResponder()
               
                UIView.animate(withDuration: 0.25, animations: {
                
                    self.layoutIfNeeded()
                    
                })
                
            }else{
               
                
                    self.actionTextField.isHidden = true
                    
                    self.subCategoryQtyTextField.isHidden = false
                    self.subCategoryTextField.customPlaceholder(color: AppColor.Shared.greyText, text: "Model")
                    self.subCategoryTextField.rightView = nil
                self.subCategoryTextField.addDonButton()
                    self.subCategoryTextField.delegate = self
                    self.subCategoryTextField.becomeFirstResponder()
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                })
                
            }
            
            productListingButtonAdd(isZeroProject: isZeroProject)
        }
    }
    
    
    @IBOutlet weak var productBGView: UIView!
    @IBOutlet weak var productStackView: UIStackView!
    @IBOutlet weak var categoryTextField: ProjectDetailsCategoryTF!{
        didSet{
            
        categoryTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
        }
    }
    
    @IBOutlet weak var subCategoryStackView: UIStackView!
    @IBOutlet weak var subCategoryTextField: ProjectDetailsProductTF!
    
    @IBOutlet weak var subCategoryQtyTextField: UITextField!
    
    @IBOutlet weak var mrpTextField: ProjectDetailsMRPTF!{
        didSet{
            mrpTextField.delegate = self
            self.mrpTextField.addDonButton()
        }
    }
    @IBOutlet weak var offerPriceTextField: ProjectDetailsOfferTF!{
        didSet{
            offerPriceTextField.delegate = self
            self.offerPriceTextField.addDonButton()
        }
    }
    @IBOutlet weak var priorityTextField: ProjectDetailsPriorityTF!{
        didSet{
            
            priorityTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
        }
    }
    
    @IBOutlet weak var scaningButton: UIButton!
    @IBOutlet weak var enquiryNoteTextField: ProjectDetailEnquiryNoteTF!{
        didSet{
            
            enquiryNoteTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
        }
    }
    
    @IBOutlet weak var statusTextField: ProjectDetailsStatusTF!{
        didSet{
            
            statusTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
        }
    }
    
    
    //@IBOutlet weak var followUpView: UIView!
    
    @IBOutlet weak var actionTextField: UITextField!
    
    @IBOutlet weak var actionTypeTextField: ProjectDetailsActionTypeTF!{
        didSet{
            
            actionTypeTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
        }
    }
    
    @IBOutlet weak var dateTextField: ProjectDetailsDateTF!{
        didSet{
            
            dateTextField.setBorder(width: 0.5, borderColor: AppColor.Shared.red_light)
            
            
        }
    }
    
    
    
    @IBOutlet weak var nameTextField: ProjectDetailsUserTF!
    
    
    // PRODUCT LISTING VIEW
    
    
    @IBOutlet weak var productAddStackView: UIStackView!
    @IBOutlet weak var productListingView: UIView!
    @IBOutlet weak var productResetButton: UIButton!
    @IBOutlet weak var productAddButton: UIButton!
    
    
    
    @IBOutlet weak var productlListingTableView: ProductAddTableView!
    
    lazy var productaddList: [MultiProductAddModel] = []{
        didSet{
            self.productlListingTableView.reloadData()
            
            self.tableHeight.constant = self.productlListingTableView.contentSize.height + CGFloat(productaddList.count * 21)

        }
    }
    
    var clickAddProduct:Bool?{
        didSet{
            switch clickAddProduct{
            case true:
                
                self.productAddStackView.showViews(showView: productListingView)
               
                
                
            default:
                
                self.productAddStackView.hideViews(hideView: self.productListingView)
                
                
            }
        }
    }
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    weak var productDelegate : ProductModelDelegate?
    weak var enquiryDelegate : ProductEnquiryDelegate?
    weak var quantityDelegate : QuantityDelegate?
    weak var offerPriceDelegate : ProductOfferPriceDelegate?
    
    var modelCode:String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.enquiryNoteTextField.addDonButton()
        self.enquiryNoteTextField.delegate = self
        self.subCategoryQtyTextField.delegate = self
        self.productlListingTableView.dataSource = self
        self.productlListingTableView.delegate = self
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func productListingButtonAdd(isZeroProject:NSNumber){
        
        var productButtonConstraints = [NSLayoutConstraint]()
        
        productButtonConstraints.append(self.subCategoryTextField.productButton.leadingAnchor.constraint(equalTo: self.subCategoryTextField.leadingAnchor, constant: 0))
        
        productButtonConstraints.append(self.subCategoryTextField.productButton.trailingAnchor.constraint(equalTo: self.subCategoryTextField.trailingAnchor, constant: 0))
        
        productButtonConstraints.append(self.subCategoryTextField.productButton.topAnchor.constraint(equalTo: self.subCategoryTextField.topAnchor, constant: 0))
        
        productButtonConstraints.append(self.subCategoryTextField.productButton.bottomAnchor.constraint(equalTo: self.subCategoryTextField.bottomAnchor, constant: 0))
        
        if isZeroProject == 0{
            self.subCategoryTextField.addSubview(self.subCategoryTextField.productButton)
            
            NSLayoutConstraint.activate(productButtonConstraints)
        }else{
            self.subCategoryTextField.productButton.removeFromSuperview()
            NSLayoutConstraint.deactivate(productButtonConstraints)
        }
    }

}


extension ProjectProductDetailsTVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var currentString : NSString = ""
        var newString : NSString = ""
        
        if textField == subCategoryTextField{
        currentString  = textField.text!  as NSString
        newString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        
        modelCode = newString as String
            return newString.length <= 30
            
        }else if textField == offerPriceTextField{
            let controller = UIViewController()
            let result = controller.currencyPricePointFormateMethod(textField, shouldChangeCharactersIn: range, replacementString: string)
            return result
        }else if textField == offerPriceTextField || textField == mrpTextField {
            let vc = UIViewController()
            let result = vc.currencyPricePointFormateMethod(textField, shouldChangeCharactersIn: range, replacementString: string)
             
             return result
        }else{
            
            currentString  = textField.text!  as NSString
            newString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 80
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == subCategoryTextField{
            productDelegate?.getProductModel(model: modelCode)
        }
        
        if textField == enquiryNoteTextField{
            enquiryDelegate?.getEnquiryText(text: textField.text ?? "")
        }
        
        if textField == subCategoryQtyTextField{
            quantityDelegate?.maxQuantity(cell: self,qty: textField.text!)
        }
        
        if textField == offerPriceTextField{
            offerPriceDelegate?.getOfferPrice(value: textField.text ?? "")
        }
        
    }
}

extension ProjectProductDetailsTVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.productaddList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadGenerationProductAddCell) as! LGProductAddTVC
        
        let info = self.productaddList[indexPath.item]
        
        cell.categoryView.HeaderDetailTF.setTextFieldValue(info.CategoryName)
        
        cell.productView.HeaderDetailTF.setTextFieldValue(info.ProductName)
        
        cell.priorityView.HeaderDetailTF.setTextFieldValue(info.PriorityName)
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
   
}


