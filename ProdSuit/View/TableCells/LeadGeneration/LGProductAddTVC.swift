//
//  LGProductAddTVC.swift
//  ProdSuit
//
//  Created by MacBook on 19/07/23.
//

import UIKit

class LGProductAddTVC: UITableViewCell {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var categoryView: TextFieldWithNameView!{
        didSet{
            self.categoryView.HeaderNameLabel.setLabelValue("Category")
        }
    }
    @IBOutlet weak var productView: TextFieldWithNameView!{
        didSet{
            self.productView.HeaderNameLabel.setLabelValue("Product")
        }
    }
    @IBOutlet weak var priorityView: TextFieldWithNameView!{
        didSet{
            self.priorityView.HeaderNameLabel.setLabelValue("Priority")
        }
    }
    @IBOutlet weak var offerPriceView: TextFieldWithNameView!{
        didSet{
            self.offerPriceView.HeaderNameLabel.setLabelValue("Offer Price")
        }
    }
    @IBOutlet weak var actionView: TextFieldWithNameView!{
        didSet{
            self.actionView.HeaderNameLabel.setLabelValue("Action")
        }
    }
    @IBOutlet weak var actionTypeView: TextFieldWithNameView!{
        didSet{
            self.actionTypeView.HeaderNameLabel.setLabelValue("Action Type")
        }
    }
    
    @IBOutlet weak var actionDetailsView: UIView!
    
    @IBOutlet weak var followUpView: TextFieldWithNameView!{
        didSet{
            self.followUpView.HeaderNameLabel.setLabelValue("Follow Up Date")
        }
    }
    
    @IBOutlet weak var editRemoveView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
