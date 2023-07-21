//
//  PunchInOutVC.swift
//  ProdSuit
//
//  Created by MacBook on 03/07/23.
//

import UIKit

protocol AttendanceChangeProtocol:AnyObject{
    func changeAttendance(status:Bool)
}

class PunchInOutVC: UIViewController {
    
    
    @IBOutlet weak var attendanceMarkedView: UIView!
    @IBOutlet weak var punchPopUpView: UIView!
    
    @IBOutlet weak var noButton: PunchPopUpNoBtn!
    @IBOutlet weak var yesButton: PunchPopUpYesBtn!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var punchStackView: UIStackView!
    @IBOutlet weak var messageLbl: PunchPopUpTextLbl!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var titleView: PunchPopUpTitleLbl!
    @IBOutlet weak var popUpImageView: BlackTintColorImageView!
    
    
    
    //==================== ATTENDANCE MARKING VIEW OUTLET ===============
    
    @IBOutlet weak var userImageView: PunchUserImageView!
    @IBOutlet weak var userNameLbl: PunchNameLbl!
    @IBOutlet weak var userRoleLbl: PunchTextLbl!
    
    
    @IBOutlet weak var dateLbl: PunchTextLbl!
    @IBOutlet weak var timeLbl: PunchTextLbl!
    @IBOutlet weak var addressLbl: PunchTextLbl!
    @IBOutlet weak var punchStatus: PunchTextLbl!
    
    @IBOutlet weak var punchConfirmButton: PunchConfirmBtn!
    
    //var has_attendanceMarked:Bool=false
    weak var attendanceDelegate:AttendanceChangeProtocol?
    var status:Bool = false
    var fromvc = ""
    
    var userInfo:PunchedUserDetailsModel?{
        didSet{
            if let info = userInfo{
                let dateString = info.date != "" ?  DateTimeModel.shared.formattedDateFromString(dateString: info.date, withFormat: "dd-MM-yyyy")! : "NA"
                self.dateLbl.setLabelValue(dateString)
                
                self.timeLbl.setLabelValue(info.time != "" ? info.time : "NA")
                self.addressLbl.setLabelValue(info.address != "" ? info.address : "NA")
            }
        }
    }
    
    let commonNetworkVM = SharedNetworkCall.Shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLbl.setLabelValue(preference.User_UserName)
        self.userRoleLbl.setLabelValue(preference.User_UserRole)
        let date_time_Vm = DateTimeModel.shared.fetchCurrentDateAndTime()
        print("date:\(date_time_Vm.date) -- time:\(date_time_Vm.time)")
        userInfo = PunchedUserDetailsModel.init(userImageString: "", userName: preference.User_UserCode, userRole: preference.User_UserRole, date: preference.User_EnteredDate, time: preference.User_EnteredTime, address: preference.User_loc_LocLocationName)
        
        attendanceMarkedCheck(status)
        
       print("coordinate:\(punch_loc_coordinate) == \(punch_address)")
        
        if fromvc == ""{
           
            hideAttendancePopupView(hideView: punchPopUpView, showView: attendanceMarkedView)
         
        }else{
            let message = "You have not marked attendance yet, please mark attendance first"
            self.messageLbl.setLabelValue(message)
            hideAttendancePopupView(hideView: attendanceMarkedView, showView: punchPopUpView)
            
        }
    }
    
    
    func attendanceMarkedCheck(_ attedanceChecked:Bool) {
        switch status{
        case true:
            

            punchStatus.setLabelValue("Punch In")
            punchConfirmButton.setTitle("Punch Out", for: .normal)
            punchStatus.setTextColor(AppColor.Shared.green)
        default:
            
            
           
            punchStatus.setLabelValue("Punch Out")
            punchConfirmButton.setTitle("Punch In", for: .normal)

            
            punchStatus.setTextColor(AppColor.Shared.red)
        }
    }
    
    func hideAttendancePopupView(hideView:UIView,showView:UIView){
        
        if messageLbl.text == "You have not marked attendance yet, please mark attendance first"{
        hideView.alpha = 0
        showView.alpha = 1
        }else{
            hideView.alpha = 1
            showView.alpha = 1
        }
        self.view.bringSubviewToFront(showView)
        self.view.sendSubviewToBack(hideView)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: - attendanceMarkingAPICall()
    func attendanceMarkingAPICall(dateTime:(date:String,time:String)){
        
        guard let info = userInfo else {
            return
        }
        let date_time_Vm = dateTime
        let latitude = "\(punch_loc_coordinate.0)"
        let longitude = "\(punch_loc_coordinate.1)"
        
        commonNetworkVM.attendanceAPIManager?.attendanceMarkingAPICall(dateTime:date_time_Vm,lat: latitude, lon: longitude, status: status, info) { responseHandler in
            print(responseHandler.info)
            
            let statusCode = responseHandler.statusCode
            let message = responseHandler.message
            
            
            
            if statusCode == 0{
                
                self.hideAttendancePopupView(hideView: self.punchPopUpView, showView: self.attendanceMarkedView)
                
               self.popupAlert(title: "", message: message, actionTitles: [okTitle], actions: [{action1 in
                
                  
                   print("date:\(dateTime.date) -- time:\(dateTime.time)")
                   
                   
                   preference.User_Status = !self.status
                   
                   
                   self.userInfo = PunchedUserDetailsModel.init(userImageString: "", userName: preference.User_UserCode, userRole: preference.User_UserRole, date: preference.User_EnteredDate, time: preference.User_EnteredTime, address: preference.User_loc_LocLocationName)
                       self.status = preference.User_Status
                   
                   self.punchStatus.setLabelValue(self.status == true ? "Punch In" : "Punch Out")
                   self.punchConfirmButton.setTitle(self.status == true ? "Punch Out" : "Punch In", for: .normal)
                   self.punchStatus.setTextColor(self.status == true ? AppColor.Shared.green : AppColor.Shared.red)
                       
                   
               },nil])
                
                
        
            }else{
                self.popupAlert(title: "", message: message, actionTitles: [okTitle], actions: [{action1 in },nil])
            }
            
        }
        
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        
        if fromvc == ""{
            hideAttendancePopupView(hideView: punchPopUpView, showView: attendanceMarkedView)
        }else{
            
            self.dismiss(animated: true) {
                self.attendanceDelegate?.changeAttendance(status: self.status)
            }
        }
        
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        
        if messageLbl.text == "You have not marked attendance yet, please mark attendance first"{
            hideAttendancePopupView(hideView: punchPopUpView, showView: attendanceMarkedView)
        }else{
            let date_time_Vm = DateTimeModel.shared.fetchCurrentDateAndTime()
            attendanceMarkingAPICall(dateTime: date_time_Vm)
        }
        
        
            
 
            
        
        
        
    }
    
    
    @IBAction func punchConfirmButtonAction(_ sender: UIButton) {
        
        
        
        
        let message = status == true ? "Do you want to punch out current session ?" : "Do you want to punch in ?"
        
       
        
        self.messageLbl.setLabelValue(message)
        
//        self.popUpImageView.transform  = status == true ?  CGAffineTransform.init(rotationAngle: CGFloat.pi) : CGAffineTransform.init(rotationAngle: 2 * CGFloat.pi)
//             status == true ? self.popUpImageView.setBGColor(color: AppColor.Shared.red) : self.popUpImageView.setBGColor(color: AppColor.Shared.green)
        
        
        hideAttendancePopupView(hideView: attendanceMarkedView, showView: punchPopUpView)
        
    }
    
    @IBAction func punchCancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.attendanceDelegate?.changeAttendance(status: self.status)
        }
        
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
