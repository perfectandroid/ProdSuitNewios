//
//  LeadGenerationVC.swift
//  ProdSuit
//
//  Created by MacBook on 03/04/23.
//

import UIKit
import Combine
import GoogleMaps
import AVFoundation
import PhotosUI
import MLKitBarcodeScanning
import MLKitVision



struct leadGeneratModel{
    var name:String
    var list:[String]
    var rows:Int
}

class LeadGenerationVC: UIViewController,GeneralSettingAPIProtocol,AVCaptureMetadataOutputObjectsDelegate{
    
   lazy var sectionLabel : UILabel = {
        let headerLabel = UILabel()
       //headerLabel.translatesAutoresizingMaskIntoConstraints = false
       headerLabel.font = AppFonts.Shared.Regular.withSize(14)
       headerLabel.textColor = AppColor.Shared.greyText
      // headerLabel.font =
        return headerLabel
    }()
    
    var leadGenerateConfirmList : [LeadConfirmationDetails] = []
    
    var leadGenerationValidationVM : LeadGenerationValidationModel = LeadGenerationValidationModel(brockenRules: [])
    lazy var emailValidatorVm : EmailValidator = EmailValidator(email: "")
    
   // var DashboardNavController : UINavigationController?
    var expandedSectionHeaderNumber = -1
    var kHeaderSectionTag = 200
    var coordinates: (lat: Double, lon: Double) = (0, 0)
    var keyboardYposition:CGFloat = 0
    var expectedDateString : String = currentDateString
    var leadWalkingList : [WalkingCustomerDetailsInfo] = []
    
    {
        didSet{
            
        }
    }
    var list : [leadGeneratModel] = []
    lazy var leadFromDetailsInfoList : [LeadFromDetailsInfo] = []
    lazy var leadThroughDetailsInfoList : [LeadThroughDetailsInfo] = []
    lazy var leadMediaSubMediaInfoList : [SubMediaTypeDetailsInfo] = []
    lazy var leaduserCollectionInfoList : [CollectedByUsersInfo] = []
    lazy var imagePickerVm : ImagePickerManager = ImagePickerManager()
    
    lazy var leadCustomerSearchNameInfoList : [CustomerDetailsInfo<String>] = []
    lazy var leadCustomerSearchPhoneInfoList : [CustomerDetailsInfo<Int>] = []
    
    lazy var pincodeDetailsList : [PincodeDetailsListInfo] = []
    
    var leadGenerationDefaultValueSettingsInfo : LeadGenerationDefaultValueModel?
    weak var mapViewViewcontroller:MapviewVC?
    var leadDetailsDate:String=""{
        didSet{
            if leadDetailsDate != ""{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 0 + 1), with: .none)
            }
        }
    }
    
    var selectedUserFromCollectionList : SelectedUserFromCollectionDetails = SelectedUserFromCollectionDetails(){
        didSet{
            if self.selectedUserFromCollectionList.Name != ""{
            self.leadGenerateTableView.reloadSections(IndexSet(integer: 0 + 1), with: .none)
           }
        }
    }
    
    var locationAddress:String = ""{
        didSet{
            if locationAddress != ""{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 4 + 1), with: .none)
            }
        }
    }
    
    
    var selectedLeadSourceInfo : LeadFromSelectedInfo = LeadFromSelectedInfo(ID_LeadFrom: -1, LeadFromName: "Lead Source", LeadFromType: -1){
        didSet{
            if selectedLeadSourceInfo.LeadFromType != -1{
            self.leadGenerateTableView.reloadSections(IndexSet(integer: 0 + 1), with: .none)
            }
        }
    }
    
    var selectedLeadThrough:SelectedLeadThroughDetails = SelectedLeadThroughDetails(ID_LeadThrough: -1, LeadThroughName: "", HasSub: -1){
        didSet{
            if selectedLeadThrough.HasSub != -1{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 0 + 1), with: .none)
            }
        }
    }
    
    var selectedSubMedia:SelectedSubMediaDetails = SelectedSubMediaDetails(ID_MediaSubMaster: -1, SubMdaName: ""){
        didSet{
            if selectedSubMedia.ID_MediaSubMaster != -1{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 0 + 1), with: .none)
            }
        }
    }
    
    var selecteCustomerDetailsInfo : SelectedCustomerDetailsInfo = SelectedCustomerDetailsInfo(ID_Customer: -1, CusNameTitle: "", CusName: "", CusAddress1: "", CusAddress2: "", CusEmail: "", CusPhnNo: "", Company: "", CountryID: -1, CntryName: "", StatesID: -1, StName: "", DistrictID: -1, DtName: "", PostID: -1, PostName: "", FK_Area: -1, Area: "", CusMobileAlternate: "", Pincode: "", Customer_Type: -1){
        didSet{
            if selecteCustomerDetailsInfo.ID_Customer != -1{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 1 + 1), with: .none)
            }
        }
    }
    
    var selectedDefaultValue:SelectedLeadGenerationDefaultValue=SelectedLeadGenerationDefaultValue(){
        didSet{
            if selectedDefaultValue.DistrictName != "" || selectedDefaultValue.StateName != "" || selectedDefaultValue.Country != "" || selectedDefaultValue.Area != "" || selectedDefaultValue.PostName != ""{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 2 + 1), with: .none)
            }
        }
    }
    
    lazy var countryDetailsList : [CountryDetailsListInfo] = []
    lazy var stateDetailsList : [StatesDetailsListInfo] = []
    
    lazy var districtDetailsList : [DistrictDetailsListInfo] = []
    lazy var areaDetailsList : [AreaDetailsListInfo] = []
    lazy var postDetailsList : [PostDetailsListInfo] = []
    
    
    
    
    var moreInfoPinCode : String = ""{
        didSet{
            if moreInfoPinCode.count >= 6{
                self.selectedDefaultValue.Pincode = moreInfoPinCode
            }
        }
    }
    
    var searchNameorMobileList : [String] = ["Name","Mobile"]
    var honorificsList : [String] = ["Mr","Mrs","Miss","M/s","Dr","Ms","Fr","Sr"]
    
    var searchTypeList:[SearchByNameOrMobileVM] = [SearchByNameOrMobileVM(name: "Name", submode: "1"),SearchByNameOrMobileVM(name: "Mobile", submode: "2")]
    
    
    
    var selectedCustomerSearchString : String = ""{
        didSet{
            if selectedCustomerSearchString != ""{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 1 + 1), with: .none)
            }
        }
    }
    
    var selectedHonorificString : String = "Mr"{
        didSet{
            if selectedHonorificString != ""{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 1 + 1), with: .none)
            }
        }
    }
    
    
    // =========== project product details ========
    
    lazy var categoryList : [CategoryListInfo] = []
    lazy var productList : [ProductListInfo] = []
    lazy var priorityList : [PriorityListInfo] = []
    lazy var actionList : [FollowUpActionDetailsListInfo] = []
    lazy var actionTypeList : [FollowUpTypeDetailsListInfo] = []
    lazy var employeeList : [EmployeeDetailsListInfo] = []
    
    var selectedProductDetailInfo : SelectedProductDetailsInfo = SelectedProductDetailsInfo(){
        didSet{
            if selectedProductDetailInfo.CategoryName != ""{
                
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 3 + 1), with: .none)
            }
        }
    }
    
    let images = ["requested_color 1","leadfrom_color 1","user_color 1","communication_color","product_color 1","ic_location1","upload_color 1"]
    
    let defaultImage = UIImage(named: "updef")

    lazy var uploadImagList : [UIImage?] = [defaultImage,defaultImage]{
        didSet{
            if uploadImagList.first != defaultImage || uploadImagList.last != defaultImage{
                self.leadGenerateTableView.reloadSections(IndexSet(integer: 5 + 1), with: .none)
                print(self.uploadImagList)
            }
        }
    }
    
    lazy var imageStringArray : [String] = []{
        didSet{
            print(imageStringArray)
        }
    }
    
    var productModelString = ""
    
    var contactName : String = ""
    var contact_numbers : String = ""
    var whatsapp_numbers : String = ""
    var company_name : String = ""
    var customer_email : String = ""

    
   
    func searchSelectedType(_ search:String) -> SearchByNameOrMobileVM {
        let item   =  searchTypeList.filter{ return $0.name == search }
        return item.first!
    }
    
    var generalSettingsValue = false
    var punchStatus:Bool = false
    
    var searchNameOrMobileText : String = ""
    
    let commonNetworkVM  = SharedNetworkCall.Shared
    
    var leadGenerationVm:LeadGenerationVCViewModel!
    
    lazy var keyboardCancellable = Set<AnyCancellable>()
    
    lazy var keyboardManager = KeyboardHeightPublisher

    @IBOutlet weak var leadGenerateTableView: UITableView!
    
     func tableviewDelegatesCall() {
        self.leadGenerateTableView.dataSource = self
        self.leadGenerateTableView.delegate = self
       
        self.leadGenerateTableView.separatorStyle = .none
    }

    fileprivate func keyboardHandler() {
        keyboardManager
          
          .sink { completed in
            print(completed)
        } receiveValue: { height in
            print(height)
            
            
            self.leadGenerateTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            self.leadGenerateTableView.scrollIndicatorInsets = self.leadGenerateTableView.contentInset
            
        }.store(in: &keyboardCancellable)
    }
    
    var clickAddProduct = false
    
    
    //FIXME: - SCANING BAR CODE VARIABLE()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView?
    var scannerBounds = CALayer()
    var uploadButton : UIButton?
    let format:BarcodeFormat = .all
    var visionImage : VisionImage!
    var barcodeStringValue  = ""
    var successErrorView : SuccessErrorView!
    
    var scannedAddedItemList : [MultiProductAddModel] = []
    var scannedItemList : [ItemSearchDataInfoModel] = []
    
    
   lazy var scanbackgroundView : UIView = {
        
       let vw = UIView()
       
       vw.translatesAutoresizingMaskIntoConstraints = false
       vw.setBGColor(color: AppColor.Shared.coloBlack)
       
       return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
        
        getGeneralSettingsAPICall()
        
        
        
        
        
        
        if #available(iOS 15.0, *) {
            self.leadGenerateTableView.sectionHeaderTopPadding  = 0
        } else {
            
            // Fallback on earlier versions
            leadGenerateTableView.contentInsetAdjustmentBehavior = .never
        }
        self.successErrorView = SuccessErrorView(bgView: self.leadGenerateTableView)
        keyboardHandler()
        self.tableviewDelegatesCall()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getGeneralSettingsAPICall()
        
        self.list = [leadGeneratModel(name: "Lead Request", list: [], rows: 0),leadGeneratModel(name: "Lead Details", list: ["lead details"], rows: 1),leadGeneratModel(name: "Customer Details", list: ["name","result","search"],rows: 3),leadGeneratModel(name: "More Communication Info", list: ["More Info"], rows: 1),leadGeneratModel(name: "Project/Product Details", list: ["Project Product Details"], rows: 1),leadGeneratModel(name: "Location Details", list: ["Location Details"], rows: 1),leadGeneratModel(name: "Upload Images", list: ["Upload Images"], rows: 1)]
        
       
        initializeTableData()
           
            
            
            
//            self.selectedDefaultValue = SelectedLeadGenerationDefaultValue(ID_Employee: info.ID_Employee, EmpFName: info.EmpFName, ID_BranchType: info.ID_BranchType, BranchType: info.BranchType, ID_Branch: info.ID_Branch, Branch: info.Branch, FK_Department: info.FK_Department, Department: info.Department, FK_Country: info.FK_Country, Country: info.Country, FK_States: info.FK_States, StateName: info.StateName, FK_District: info.FK_District, DistrictName: info.DistrictName,FK_Area: -1,Area: "",PostID: 0,PostName:"", Pincode:"", address:"", FK_Place:0, Place:"")
        
        
        self.leadGenerationVm = LeadGenerationVCViewModel(controller: self)
        
        self.punchStatus = preference.User_Status
        attendanceMarkCheck()
        
    }
    
    func getGeneralSettingsAPICall(){
        
        self.getGeneralSettingsAPICall(commonNetworkVM: commonNetworkVM) { gsValue in
            print("general settings:\(gsValue)")
            self.generalSettingsValue = gsValue
            self.leadGenerateTableView.reloadData()
        }
    }
    
    
    
    fileprivate func attendanceMarkCheck() {
        switch self.punchStatus{
        case false:
            let punchPopUpcheckVC = AppVC.Shared.punchPopUpPage
            punchPopUpcheckVC.status = punchStatus
            punchPopUpcheckVC.fromvc = "lead"
            punchPopUpcheckVC.attendanceDelegate = self
            punchPopUpcheckVC.modalTransitionStyle = .crossDissolve
            punchPopUpcheckVC.modalPresentationStyle = .overCurrentContext
            self.present(punchPopUpcheckVC, animated: false)
        default:
            print("attendance marked")
        }
    }


   func initializeTableData(){
       if let info = leadGenerationDefaultValueSettingsInfo{
          
           
           self.selectedUserFromCollectionList.ID_CollectedBy = info.ID_Employee
           self.selectedUserFromCollectionList.Name = info.EmpFName
           self.selectedUserFromCollectionList.DepartmentName = info.Department
           self.selectedUserFromCollectionList.DesignationName = ""

       
       }
       
       self.selecteCustomerDetailsInfo = SelectedCustomerDetailsInfo(ID_Customer: -1, CusNameTitle: "", CusName: "", CusAddress1: "", CusAddress2: "", CusEmail: "", CusPhnNo: "", Company: "", CountryID: -1, CntryName: "", StatesID: -1, StName: "", DistrictID: -1, DtName: "", PostID: -1, PostName: "", FK_Area: -1, Area: "", CusMobileAlternate: "", Pincode: "", Customer_Type: -1)
       
       self.selectedProductDetailInfo.ID_Employee = self.leadGenerationDefaultValueSettingsInfo?.ID_Employee
       self.selectedProductDetailInfo.DepartmentName = self.leadGenerationDefaultValueSettingsInfo?.Department
       self.selectedProductDetailInfo.EmpName = self.leadGenerationDefaultValueSettingsInfo?.EmpFName
       self.selectedProductDetailInfo.DesignationName = ""
       
       if let info = leadGenerationDefaultValueSettingsInfo{
           
           self.selectedDefaultValue.ID_Employee =  info.ID_Employee
           self.selectedDefaultValue.EmpFName =  info.EmpFName
           
           self.selectedDefaultValue.ID_BranchType = info.ID_BranchType
           self.selectedDefaultValue.BranchType =  info.BranchType
           
           self.selectedDefaultValue.ID_Branch  = info.ID_Branch
           self.selectedDefaultValue.Branch =  info.Branch
           
           self.selectedDefaultValue.FK_Department = info.FK_Department
           self.selectedDefaultValue.Department = info.Department
           
           self.selectedDefaultValue.FK_Country = info.FK_Country
           self.selectedDefaultValue.Country = info.Country
           
           self.selectedDefaultValue.FK_States = info.FK_States
           self.selectedDefaultValue.StateName = info.StateName
           
           self.selectedDefaultValue.FK_District = info.FK_District
           self.selectedDefaultValue.DistrictName = info.DistrictName
           
           self.selectedDefaultValue.FK_Area = -1
           self.selectedDefaultValue.Area = ""
           
           self.selectedDefaultValue.PostID = 0
           self.selectedDefaultValue.PostName = ""
           
           self.selectedDefaultValue.Pincode = ""
           self.selectedDefaultValue.address = ""
           
           self.selectedDefaultValue.FK_Place = 0
           self.selectedDefaultValue.Place = ""
       }
   }
    
    
    

    @IBAction func backButtonAction(_ sender: BackButtonCC) {
        
        self.resetPage()
        self.leadGenerateTableView.reloadData()
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.resetPage()
        initializeTableData()
        self.leadGenerationVm.leadCollectedByUserAPICall()
        self.leadGenerateTableView.reloadData()
    }
    
    fileprivate func fetchValidationDetails() {
        
        self.leadGenerateConfirmList = []
        let enquiryDate = self.leadDetailsDate == "" ? DateTimeModel.shared.stringDateFromDate(Date()) : leadDetailsDate
        let product_project = self.self.selectedProductDetailInfo.Project == 0 ? "Product" : "Project"
        self.leadGenerateConfirmList = [LeadConfirmationDetails(sectionTitle: "LEAD DEATILS", row: [LeadConfirmDataRow(name: "Enquiry Date", details: enquiryDate),LeadConfirmDataRow(name: "Attended By", details: self.selectedUserFromCollectionList.Name ?? ""),LeadConfirmDataRow(name: "Lead Source", details: self.selectedLeadSourceInfo.LeadFromName),LeadConfirmDataRow(name: "\(selectedLeadSourceInfo.LeadFromName) Name", details: self.selectedLeadThrough.LeadThroughName),LeadConfirmDataRow(name: "Sub Media", details: self.selectedSubMedia.SubMdaName)]),LeadConfirmationDetails(sectionTitle: "CUSTOMER DETAILS", row: [LeadConfirmDataRow(name: "Customer Name", details: self.selecteCustomerDetailsInfo.CusName ?? ""),LeadConfirmDataRow(name: "Contact No", details: self.selecteCustomerDetailsInfo.CusPhnNo),LeadConfirmDataRow(name: "WhatsApp No", details: self.selecteCustomerDetailsInfo.whatsapp),LeadConfirmDataRow(name: "Company/Contact Person", details: self.selecteCustomerDetailsInfo.Company),LeadConfirmDataRow(name: "Email", details: self.selecteCustomerDetailsInfo.CusEmail)]),LeadConfirmationDetails(sectionTitle: "MORE COMMUNICATION INFO", row: [LeadConfirmDataRow(name: "Address1", details: self.selectedDefaultValue.address ?? ""),LeadConfirmDataRow(name: "Address 2", details: self.selectedDefaultValue.Place ?? ""),LeadConfirmDataRow(name: "Country", details: self.selectedDefaultValue.Country ?? ""),LeadConfirmDataRow(name: "State", details: self.selectedDefaultValue.StateName ?? ""),LeadConfirmDataRow(name: "District", details: self.selectedDefaultValue.DistrictName ?? ""),LeadConfirmDataRow(name: "Area", details: self.selectedDefaultValue.Area ?? ""),LeadConfirmDataRow(name: "Pincode", details: self.selectedDefaultValue.Pincode ?? "")]),LeadConfirmationDetails(sectionTitle: "PROJECT/PRODUCT", row: [LeadConfirmDataRow(name: "Category", details: "\(self.selectedProductDetailInfo.CategoryName ?? "") (\(product_project))" ),LeadConfirmDataRow(name: "Enquiry Note", details: self.selectedProductDetailInfo.EnquiryText ?? ""),LeadConfirmDataRow(name: "Action", details: self.selectedProductDetailInfo.NxtActnName ?? ""),LeadConfirmDataRow(name: "Action Type", details: self.selectedProductDetailInfo.ActnTypeName ?? ""),LeadConfirmDataRow(name: "Followup Date", details: self.selectedProductDetailInfo
            .date ?? ""),LeadConfirmDataRow(name: "Assigned To", details: self.selectedProductDetailInfo.EmpName ?? ""),LeadConfirmDataRow(name: "Location", details: self.locationAddress)])]
        
        leadGenerateConfirmList.map{
            let subitem = $0.row.map { $0 }
            print("\($0.sectionTitle)\n==================\n\(subitem)")
        }
        
        leadGenerationValidationVM.leadDateString = enquiryDate
        leadGenerationValidationVM.customerHonerString = self.selectedHonorificString
        leadGenerationValidationVM.customerNameString = self.selecteCustomerDetailsInfo.CusName ?? ""
        leadGenerationValidationVM.categoryString = self.selectedProductDetailInfo.CategoryName ?? ""
        leadGenerationValidationVM.priorityString = self.selectedProductDetailInfo.PriorityName ?? ""
        leadGenerationValidationVM.enquiry = self.selectedProductDetailInfo.EnquiryText ?? ""
        
        leadGenerationValidationVM.actionType = self.selectedProductDetailInfo.Status == nil ? "" : "\(self.selectedProductDetailInfo.Status!)"
        
        leadGenerationValidationVM.subActionType = self.selectedProductDetailInfo.ActnTypeName ?? ""
        
        leadGenerationValidationVM.project_dateString = self.selectedProductDetailInfo.date ?? DateTimeModel.shared.stringDateFromDate(Date())
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
       
        
        fetchValidationDetails()
        
        if !leadGenerationValidationVM.isValid{
           print("validation success")
            
            if self.punchStatus == false{
                attendanceMarkCheck()
            }else{
            let confirmPage = AppVC.Shared.leadGenConfirmPage
            confirmPage.modalTransitionStyle = .coverVertical
            confirmPage.modalPresentationStyle = .overCurrentContext
            confirmPage.leadConfirmDetailsDelegate = self
            confirmPage.leadGenerateConfirmList = leadGenerateConfirmList
            self.present(confirmPage, animated: true, completion: nil)
            }
            
        }else{
            self.popupAlert(title: "",message: leadGenerationValidationVM.brockenRules.first?.message, actionTitles: [okTitle], actions: [{action1 in
                
            },nil])
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
    
    
    
    
    
    func resetPage(){
         
         leadFromDetailsInfoList  = []
         leadThroughDetailsInfoList = []
         leadMediaSubMediaInfoList  = []
         leaduserCollectionInfoList  = []
         leadCustomerSearchNameInfoList = []
         leadCustomerSearchPhoneInfoList  = []
         pincodeDetailsList  = []
        
         countryDetailsList = []
         stateDetailsList  = []
        
         districtDetailsList = []
         areaDetailsList  = []
         postDetailsList = []
        
         categoryList = []
         productList = []
         priorityList  = []
         actionList  = []
         actionTypeList  = []
         employeeList  = []
        self.uploadImagList = [defaultImage,defaultImage]
        self.leadDetailsDate = ""
         productModelString = ""
         moreInfoPinCode  = ""
         selectedCustomerSearchString  = ""
         selectedHonorificString = ""
         selectedUserFromCollectionList = SelectedUserFromCollectionDetails(ID_CollectedBy: -1, Name: "", DepartmentName: "", DesignationName: "")
         selectedLeadSourceInfo = LeadFromSelectedInfo(ID_LeadFrom: -1, LeadFromName: "Lead Source", LeadFromType: -1)
         selectedLeadThrough = SelectedLeadThroughDetails(ID_LeadThrough: -1, LeadThroughName: "", HasSub: -1)
         selectedSubMedia = SelectedSubMediaDetails(ID_MediaSubMaster: -1, SubMdaName: "")
         selecteCustomerDetailsInfo  = SelectedCustomerDetailsInfo(ID_Customer: -1, CusNameTitle: "", CusName: "", CusAddress1: "", CusAddress2: "", CusEmail: "", CusPhnNo: "", Company: "", CountryID: -1, CntryName: "", StatesID: -1, StName: "", DistrictID: -1, DtName: "", PostID: -1, PostName: "", FK_Area: -1, Area: "", CusMobileAlternate: "", Pincode: "", Customer_Type: -1)
         selectedDefaultValue=SelectedLeadGenerationDefaultValue()
         selectedProductDetailInfo  = SelectedProductDetailsInfo()
         contactName = ""
         contact_numbers  = ""
         whatsapp_numbers = ""
         company_name  = ""
         customer_email  = ""
        self.coordinates = (0,0)
        self.imageStringArray = []
        self.leadWalkingList = []
        locationAddress = ""
        
        if expandedSectionHeaderNumber != -1{
            let index = NSIndexPath(row: 0, section: expandedSectionHeaderNumber)
            self.leadGenerateTableView.selectRow(at: index as IndexPath, animated: false, scrollPosition: .none)
            expandedSectionHeaderNumber = -1
        }
        
        expectedDateString = currentDateString
        //self.leadGenerateTableView.reloadSections(IndexSet(integer: 5), with: .none)
        
        
        
    }
    
    

}



extension LeadGenerationVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && self.list[indexPath.section].rows > 0{
            self.expandedSectionHeaderNumber = 2
            self.selecteCustomerDetailsInfo.CusName = self.leadWalkingList[indexPath.row].Customer
            self.selecteCustomerDetailsInfo.CusPhnNo = self.leadWalkingList[indexPath.row].Mobile
            self.leadGenerateTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSectionHeaderNumber == section ? list[section].list.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section{
        case 0:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadRequestCell) as! LeadRequestTVC
            if self.leadWalkingList.count > 0{
            let info  = self.leadWalkingList[indexPath.item]
            cell.cusmtomerNameLabel.text = info.Customer
            cell.mobileLabel.text = info.Mobile
            cell.assignedLabel.text = info.AssignedDate
            }
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadGenerationCell) as! LeadGenerationTVC
            
            if leadDetailsDate == ""{
                leadDetailsDate = DateTimeModel.shared.stringDateFromDate(Date())
            }
            
            cell.nameTextField.text = selectedUserFromCollectionList.Name ?? ""
            cell.leadSourceTextField.text = selectedLeadSourceInfo.LeadFromName
            cell.leadSourceFromTextField.text = selectedLeadThrough.LeadThroughName == "" ? "" : selectedLeadThrough.LeadThroughName
            cell.leadSourceSubmediaField.text = selectedSubMedia.SubMdaName == "" ? "" : selectedSubMedia.SubMdaName
            
            cell.leadSourceSubmediaField.isHidden = selectedLeadThrough.HasSub == 1 ? false : true
            cell.dateTextField.text = leadDetailsDate
            cell.dateTextField.leadDateDelegate = self
            cell.dateTextField.controller = self
            
            let type:Int = selectedLeadSourceInfo.LeadFromType as! Int
            
            
            cell.leadSourceTextField.sourceButton.addTarget(self, action: #selector(sourceListingButtonAction(_:)), for: .touchUpInside)
            
            cell.leadSourceFromTextField.sourceDetailsButton.addTarget(self, action: #selector(sourceDetailsListingButtonAction(_:)), for: .touchUpInside)
            
            
            cell.leadSourceSubmediaField.mediaButton.addTarget(self, action: #selector(sourceDetailsSubMediaListingAction(_:)), for: .touchUpInside)
            
            
            cell.nameTextField.leadNameSelectionButton.addTarget(self, action: #selector(userCollectedByButtonAction(_:)), for: .touchUpInside)
            
            leadGenerationVm.cellConfigurationLeadDetails(cell: cell, type,placeholderTxt: "\(selectedLeadSourceInfo.LeadFromName) Name")
            
            
            return cell
        case 2:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadCustomerDetailCell1) as! CustomerDetailsTVC1
                cell.searchByTF.text = selectedCustomerSearchString == "" ? searchNameorMobileList[0] : selectedCustomerSearchString
                
                if searchNameOrMobileText == ""{
                    cell.searchTF.text = ""
                }
                cell.searchTF.delegate = self
                
                cell.searchByTF.searchByNameorMobileButton.addTarget(self, action: #selector(searchByNameOrMobileButtonAction(_:)), for: .touchUpInside)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchCustomerNameOrMobileButtonAction))
                cell.searchTF.rightView?.addGestureRecognizer(tapGesture)
                
                leadGenerationVm.cellConfigurationOne(cell: cell)
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadCustomerDetailCell2) as! CustomerDetailsTVC2
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadCustomerDetailCell3) as! CustomerDetailsTVC3
                cell.textFieldDelegateCall(textField: cell.contactNumberTF)
                cell.textFieldDelegateCall(textField: cell.whatsAppNumberTF)
                cell.textFieldDelegateCall(textField: cell.customerNameTF)
                cell.textFieldDelegateCall(textField: cell.emailTF)
                cell.textFieldDelegateCall(textField: cell.companyTF)
                cell.custmerInfoDelegate = self
                cell.respectTF.honorificsButton.addTarget(self, action: #selector(honorificsButtonAction(sender:)), for: .touchUpInside)
                self.leadGenerationVm.cellConfiurationThree(cell: cell)
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadMoreCommunicationInfoCell) as! MoreCommunicationInfoTVC
            
           
            
            cell.textFieldDelegateCall(textField: cell.pincodeTF, tableView: tableView)
            
            cell.pindelegate = self
            cell.houseplaceDelegate = self
            
            cell.pincodeTF.searchButton.addTarget(self, action: #selector(searchPincodeButtonAction(sender:)), for: .touchUpInside)
            
            cell.countryTF.dropDownButton.addTarget(self, action: #selector(countryListSearchButtonAction(sender: )), for: .touchUpInside)
            
            cell.stateTF.dropDownButton.addTarget(self, action: #selector(statListSearchButtonAction(sender:)), for: .touchUpInside)
            
            cell.districtTF.dropDownButton.addTarget(self, action: #selector(districtListSearchButtonAction(sender:)), for: .touchUpInside)
            
            
            cell.locationTF.dropDownButton.addTarget(self, action: #selector(areaListSearchButtonAction(sender:)), for: .touchUpInside)
            
            
            cell.postTF.dropDownButton.addTarget(self, action: #selector(postListSearchButtonAction(sender:)), for: .touchUpInside)
            
            self.leadGenerationVm.moreInfoCell(cell: cell, info: selectedDefaultValue)
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadProjectProductDetailsCell) as! ProjectProductDetailsTVC
            let folloUpStatus : NSNumber = self.selectedProductDetailInfo.Status ?? 0
            switch folloUpStatus {
            case 2:
                cell.hasFollowUp = false
            case 3:
                cell.hasFollowUp = false
            default:
                cell.hasFollowUp = true
            }
            cell.productDelegate = self
            cell.enquiryDelegate = self
            cell.quantityDelegate = self
            cell.offerPriceDelegate = self
            cell.expectedDateTF.controller = self
            cell.expectedDateTF.delegates = self
            
            cell.expectedDateTF.setTextFieldValue(expectedDateString)
            cell.dateTextField.date_delegate = self
            cell.dateTextField.controller = self
            if self.selectedProductDetailInfo.date == nil{
                self.selectedProductDetailInfo.date = DateTimeModel.shared.stringDateFromDate(Date())
            }
            
            cell.categoryTextField.dropDownButton.addTarget(self, action: #selector(categoryButtonAction(sender:)), for: .touchUpInside)
            
            cell.subCategoryTextField.productButton.addTarget(self, action: #selector(subCategoryButtonAction(sender:)), for: .touchUpInside)
            
            cell.priorityTextField.dropDownButton.addTarget(self, action: #selector(priorityButtonAction(sender: )), for: .touchUpInside)
            
            cell.statusTextField.dropDownButton.addTarget(self, action: #selector(statusButtonAction(sender:)), for: .touchUpInside)
            
            cell.actionTypeTextField.dropDownButton.addTarget(self, action: #selector(followUpActionTypeButtonAction(sender: )), for: .touchUpInside)
            
            cell.nameTextField.dropDownButton.addTarget(self, action: #selector(followUpEmployeeButtonAction(sender:)), for: .touchUpInside)
            
            
            
            
            
            // add product action button
            
            cell.productAddButton.addTarget(self, action: #selector(productAddButtonAction(_:)), for: .touchUpInside)
            
            cell.scaningButton.addTarget(self, action: #selector(scaningButtonAction(_:)), for: .touchUpInside)
            
            // product reset action button
                        cell.productResetButton.addTarget(self, action: #selector(productRestButtonAction(_:)), for: .touchUpInside)
            
            
            self.leadGenerationVm.project_ProductDetailCell(cell: cell, info: self.selectedProductDetailInfo,clickAddProduct: self.clickAddProduct,scannedAddedItemList: self.scannedAddedItemList)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadLocationDetailsCell) as! LocationDetailsTVC
            cell.locationTF.text = self.locationAddress
            cell.locationTF.mapButton.addTarget(self, action: #selector(mapViewButtonAction(sender:)), for: .touchUpInside)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shared.leadUploadImageViewCell) as! UploadImageViewTVC
            cell.uploadFirstImageView.deleteButton.addTarget(self, action: #selector(deleteFirstImagButtonAction(sender:)), for: .touchUpInside)
            
            cell.uploadSecondImageView.deleteButton.addTarget(self, action: #selector(deleteSecondImagButtonAction(sender:)), for: .touchUpInside)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstImagViewAction(tapGestureRecognizer:)))
               tapGestureRecognizer.numberOfTapsRequired = 1
                cell.uploadFirstImageView.addGestureRecognizer(tapGestureRecognizer)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(secondImagViewAction(tapGestureRecognizer:)))
            tapGesture.numberOfTapsRequired = 1
            cell.uploadSecondImageView.addGestureRecognizer(tapGesture)
            
            self.leadGenerationVm.uploadImageCell(cell: cell)
            return cell
        default:
            return UITableViewCell()
        }
        
        
        
//        cell.textLabel?.text = list[indexPath.section].list[indexPath.item]
//        cell.textLabel?.numberOfLines = 0
        
       
    }
    
    //FIXME: - SCANNING BUTTON ACTION()
    @objc func scaningButtonAction(_ sender: UIButton){
        
        scanImage()
        
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func scanImage(){
        
        self.view.setBGColor(color: UIColor.clear)
        self.view.subviews.map{ self.view.hideViews(hideView: $0) }
        
        let center = self.view.center
        let width = self.view.frame.width * 0.5
        let height = width
        let scannerRect = CGRect(x: (center.x - width/2) , y: (center.y - width), width: width, height: height)
        
        
        
        
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
            
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            
            
            captureSession.addOutput(metadataOutput)
            if let video = previewLayer{
            metadataOutput.rectOfInterest = video.metadataOutputRectConverted(fromLayerRect: scannerRect)
                
            }
            
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr,.aztec,.ean13,.ean8,.code39,.code128,.code93]
        } else {
            failed()
            return
        }
        
        

                
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
         
        scannerBounds.frame = scannerRect
        scannerBounds.borderColor = UIColor.clear.cgColor
        scannerBounds.borderWidth = 5
        scannerBounds.contents = UIImage(named: "scanframe")?.cgImage
        scannerBounds.contentsGravity = .resizeAspect
        scannerBounds.isGeometryFlipped = true
        
        let uploadwidth = self.view.frame.width * 0.8
       
        uploadButton = UIButton()
        
        if let uploadBtn = uploadButton{
            uploadBtn.frame = CGRect.init(x: (center.x - uploadwidth/2), y: scannerRect.origin.y + scannerRect.height + 25, width: uploadwidth, height: 40)
            uploadBtn.setCornerRadius(size: 20)
    
            uploadBtn.setTitle("Upload from gallary", for: .normal)
            uploadBtn.leftImage(image: UIImage.init(named: "image")!, renderMode: .alwaysOriginal)
        
            uploadBtn.setTitleColor(AppColor.Shared.coloBlack, for: .normal)
            uploadBtn.titleLabel?.setFontSize(15, font: .regular, autoScale: true)
            uploadBtn.layoutSubviews()
        //uploadButton.title
            uploadBtn.setBGColor(color: AppColor.Shared.colorWhite)
        
        self.view.addSubview(uploadBtn)
        
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(uploadImageButtonAction(_:)))
        tapgesture.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
            uploadBtn.isUserInteractionEnabled = true
            uploadBtn.addTarget(self, action: #selector(uploadImageButtonAction(_:)), for: .touchUpInside)
        }
        
        
        
        
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.insertSublayer(previewLayer, at: 0)
//        self.previewLayer.insertSublayer(uploadButton.layer
//                                         ,above: self.scannerBounds)
        
        self.view.layer.insertSublayer(scannerBounds, above: previewLayer)
        
        

        captureSession.startRunning()
        
        
    }
    

    
    @objc func uploadImageButtonAction(_ sender : UIButton){
        
        print("select from gallary")
        
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera;
                    imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }

        }
           
         
        
         
       
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        
        
        
        if metadataObjects.count == 0 {
                
 
            return
         }

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        UIView.animate(withDuration: 3, delay: 0) {
            self.previewLayer.removeFromSuperlayer()
            self.scannerBounds.removeFromSuperlayer()
            self.uploadButton?.removeFromSuperview()
            self.view.setBGColor(color: AppColor.Shared.colorWhite)
            self.view.subviews.map{ self.view.showViews(showView: $0) }

            self.dismiss(animated: true)
        }
       
    }
    
//    func filterArrayItem<T:Hashable>(list:[T],id:Int) -> T{
//        let fetchedItem = list.filter { return Int($0.hashValue)  == id }
//        return fetchedItem.first!
//    }
    
    //FIXME: -  barcodeSearchAPIInfo()
    fileprivate func barcodeSearchAPIInfo() {
        self.commonNetworkVM.leadGenerationAPIManager?.barcodeSearchAPIInfo(self.barcodeStringValue,modelKey: "ItemList") { responseHandler in
            
            
            let statusCode = responseHandler.statusCode
            let message = responseHandler.message
            let info = responseHandler.info
            
            if statusCode == 0{
                let list  = info.value(forKey: "ItemSearchListData") as? [NSDictionary] ?? []
                
                self.scannedItemList = []
                self.scannedItemList = list.map { ItemSearchDataInfoModel.init(datas: $0) }
                let info = self.scannedItemList.first!
                self.selectedProductDetailInfo.ID_Product = NSNumber(value: Int(info.ID_Product)!)
                self.selectedProductDetailInfo.ProductName = info.ProductName
                self.selectedProductDetailInfo.ProdShortName  = info.ProdShortName
                self.selectedProductDetailInfo.MRP = info.MRP
                self.selectedProductDetailInfo.Price = info.Price
                self.selectedProductDetailInfo.ID_Category = NSNumber(value: Int(info.FK_Category)!)
                self.selectedProductDetailInfo.CategoryName = info.CategoryName
                self.selectedProductDetailInfo.Project = NSNumber(value: Int(info.Project)!)
                
                //self.scannedAddedItemList = []
//                self.scannedAddedItemList = self.scannedItemList.map{ ScannedProductInfo(id_product: $0.ID_Product, productName: $0.ProductName, prodshortname: $0.ProdShortName, mrp: $0.MRP, price: $0.Price, fk_category: $0.FK_Category, categoryname: $0.CategoryName, project: $0.Project) }
                print("list:\(self.scannedItemList)")
                
            }else{
                self.popupAlert(title: "", message: message, actionTitles: [okTitle], actions: [{action1 in },nil])
            }
            
        }
    }
    
    func found(code: String) {
        
        print("bar code \(code)")
        
        if code.count == 0{

            
            let message = "Unable to recognize valid barcode from the image"
            
            self.popupAlert(title: "", message: message, actionTitles: [okTitle], actions: [{action1 in
                            print("Category cannot be blank")
                        },nil])
            
        }else{
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.barcodeStringValue = code
            barcodeSearchAPIInfo()
         
        }
        
        
        
    }
    
    @objc func productAddButtonAction(_ sender: UIButton){
        print("product add button clicked")
        
        var multiProductAddValidation = MultiProductAddValidation(brockenRules: [])
        
        multiProductAddValidation.categoryString = self.selectedProductDetailInfo.CategoryName ?? ""
        multiProductAddValidation.enquiry = self.selectedProductDetailInfo.EnquiryText ?? ""
        multiProductAddValidation.actionType = self.selectedProductDetailInfo.Status == nil ? "" : "\(self.selectedProductDetailInfo.Status!)"

        multiProductAddValidation.subActionType = self.selectedProductDetailInfo.ActnTypeName ?? ""
        multiProductAddValidation.project_dateString = self.selectedProductDetailInfo.date ?? DateTimeModel.shared.stringDateFromDate(Date())
        multiProductAddValidation.priorityString = self.selectedProductDetailInfo.PriorityName ?? ""
        
        if multiProductAddValidation.isValid == false{
            self.popupAlert(title: "",message: multiProductAddValidation.brockenRules.first?.message, actionTitles: [okTitle], actions: [{action1 in
                
            },nil])
        }else{
            print("Add successfully")
            if let info = self.selectedProductDetailInfo as? SelectedProductDetailsInfo{
                let itemInfo =  MultiProductAddModel(Project:"\(info.Project!)", CategoryName: info.CategoryName!, ID_Category: "\(info.ID_Category ?? 0)", ModelString: info.ModelString ?? "", ID_Product: "\(info.ID_Product ?? 0)", ProductName: info.ProductName ?? "", quantity: info.quantity ?? "",ProductCode: "\(info.ProductCode ?? 0)", PriorityName: info.PriorityName ?? "", ID_Priority: "\(info.ID_Priority ?? 0)", EnquiryText: info.EnquiryText ?? "", Status: "\(info.Status ?? 0)", ID_NextAction: "\(info.ID_NextAction ?? 0)", NxtActnName: info.NxtActnName ?? "", ID_ActionType: "\(info.ID_ActionType ?? 0)", ActnTypeName: info.ActnTypeName ?? "", ActionMode: "\(info.ActionMode ?? 0)", date: info.date ?? "", ProdShortName: info.ProdShortName ?? "",MRP: info.MRP,Price: info.Price,expectedDateString: info.expectedDateString,ID_Employee: "\(info.ID_Employee ?? 0)",EmpName: info.EmpName ?? "",DepartmentName: info.DepartmentName ?? "",DesignationName: info.DesignationName ?? "")
            
                self.scannedAddedItemList.append(itemInfo)
                
                self.selectedProductDetailInfo = SelectedProductDetailsInfo()
            }
            
        }
        
        
        
        if self.scannedAddedItemList.count > 0{
           
            
            
            self.clickAddProduct = true
        }else{
            self.clickAddProduct = false
        }
                
        
        
        UIView.animate(withDuration: 0.1, delay: 0) {
       
                   self.leadGenerateTableView.reloadSections(IndexSet(integer: 3 + 1), with: .none)
       
        }
    

        
    
        
        
//        UIView.animate(withDuration: 0.1, delay: 0) {
//
//            self.leadGenerateTableView.reloadSections(IndexSet(integer: 3 + 1), with: .none)
//
//        }
        
    }
    
    @objc func productRestButtonAction(_ sender: UIButton){
        print("list : \(self.scannedAddedItemList)")
       
        
        self.selectedProductDetailInfo = SelectedProductDetailsInfo()
        
        
    }
    
    @objc func honorificsButtonAction(sender:UIButton){
        
        leadGenerationVm.honorificsAction(sender: sender)
        
    }
    
    @objc func deleteFirstImagButtonAction(sender:UIButton){
        
        self.uploadImagList[0] = self.defaultImage
        
        if imageStringArray.count > 0{
            imageStringArray.remove(at: 0)
        }
        self.leadGenerateTableView.reloadSections(IndexSet(integer: 5 + 1), with: .none)
    }
    
    @objc func deleteSecondImagButtonAction(sender:UIButton){
        
        self.uploadImagList[1] = self.defaultImage
        
        if imageStringArray.count > 0{
            imageStringArray.removeLast()
        }
        self.leadGenerateTableView.reloadSections(IndexSet(integer: 5 + 1), with: .none)
        
    }
    
    @objc func firstImagViewAction(tapGestureRecognizer: UITapGestureRecognizer){
        
       
        
        imagePickerVm.pickImage(self){ image,filename in
            image.getFileSizeInfo()
            self.uploadImagList[0] = image
            
            if let imageData = image.jpeg(.low) {
                let imageString = imageData.base64EncodedString(options: .lineLength64Characters)
                 
                self.imageStringArray.append(imageString)
                
            }
    
        }
    }
    
    
    @objc func secondImagViewAction(tapGestureRecognizer: UITapGestureRecognizer){
        
        imagePickerVm.pickImage(self){ image,filename in
            self.uploadImagList[1] = image
            if let imageData = image.jpeg(.low) {
                let imageString = imageData.base64EncodedString(options: .lineLength64Characters)
                self.imageStringArray.append(imageString)
                
            }
        }
    }
    
    
    @objc func categoryButtonAction(sender:UIButton){
        self.view.endEditing(true)
        self.selectedProductDetailInfo = SelectedProductDetailsInfo()
        leadGenerationVm.categoryListAPICall()
    }
    
    
    @objc func subCategoryButtonAction(sender:UIButton){
        self.view.endEditing(true)
        
        if self.selectedProductDetailInfo.ID_Category != nil{
            leadGenerationVm.productAPICall()
        }else{
            self.popupAlert(title: "", message: "Select a category", actionTitles: [okTitle], actions: [{action1 in
                print("Category cannot be blank")
            },nil])
        }
        
    }
    
    
    @objc func priorityButtonAction(sender:UIButton){
        self.view.endEditing(true)
        leadGenerationVm.prioriyAPICall()
    }
    
    @objc func statusButtonAction(sender:UIButton){
        self.view.endEditing(true)
        leadGenerationVm.actionAPICall()
    }
    
    @objc func followUpActionTypeButtonAction(sender:UIButton){
        self.view.endEditing(true)
        leadGenerationVm.followUpTypeAPICall()
    }
    
    @objc func followUpEmployeeButtonAction(sender:UIButton){
        self.view.endEditing(true)
        leadGenerationVm.employeeDetailsAPICall()
    }
    
    
    @objc func searchPincodeButtonAction(sender:UIButton){
        
        self.view.endEditing(true)
        
        print("pincode : \(self.moreInfoPinCode.count)")
        if self.moreInfoPinCode == ""{
            self.popupAlert(title: "", message: "Pin code cannot be blank", actionTitles: [okTitle], actions: [{action1 in
                print("pin code validation")
            },nil])
        }else{
            self.leadGenerationVm.pincodeValidationAPICall(pincode: self.moreInfoPinCode)
        }
        
        
        
        
        
    }
    
    
    @objc func countryListSearchButtonAction(sender:UIButton){
        
        leadGenerationVm.countryListingAPICall()
    }
    
    @objc func statListSearchButtonAction(sender:UIButton){
        
        leadGenerationVm.stateListingAPICall()
        
    }
    
    @objc func districtListSearchButtonAction(sender:UIButton){
        
        leadGenerationVm.districtListingAPICall()
        
    }
    
    
    @objc func areaListSearchButtonAction(sender:UIButton){
        
        leadGenerationVm.areaListingAPICall()
        
    }
    
    
    @objc func postListSearchButtonAction(sender:UIButton){
        
        leadGenerationVm.postListingAPICall()
        
    }
    
    @objc func searchCustomerNameOrMobileButtonAction(){
        leadGenerationVm.searchCustomerNameOrMobileAction()
        
    }
    
    @objc func searchByNameOrMobileButtonAction(_ sender: UIButton){
        leadGenerationVm.searchByNameOrMobile(sender)
    }
    
    @objc func sourceListingButtonAction(_ sender: UIButton){
        leadGenerationVm.sourceListing()
    }
    
    @objc func sourceDetailsListingButtonAction(_ sender: UIButton){
        leadGenerationVm.sourceDetailsListing()
    }
    
    @objc func sourceDetailsSubMediaListingAction(_ sender: UIButton){
        leadGenerationVm.sourceDetailsSubMediaListing()
    }
    
    @objc func userCollectedByButtonAction(_ sender: UIButton){
        leadGenerationVm.userCollectedByAction()
    }
    
    
    @objc func mapViewButtonAction(sender:UIButton){
        print("mapview clicked")
        
        weak var mapViewPage = AppVC.Shared.mapViewPage
        mapViewPage?.locationDelegate = self
        mapViewPage?.modalTransitionStyle = .crossDissolve
        mapViewPage?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(mapViewPage!, animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
            
        return section == 0 ? self.generalSettingsValue == true ? 50 : 0 : 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 120
        case 1:
            return 240
        case 2:
            if indexPath.row == 0{
                return 55
            }else if indexPath.row == 1{
                return 25
            }else{
                return 215
            }
        case 3:
            return 350
        case 4:
            return 250
        case 5:
            return 55
        case 6:
            return 120
        default:
            return 0 
        }
    }
    
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if list.count != 0{
            self.sectionLabel.text = "\(self.list[section].name)"
            return "        \(self.list[section].name)"
        }
        return ""
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
       
        view.backgroundColor = AppColor.Shared.greyLite
       return view
   }

  
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        //header.contentView.frame.size.height = 50
       
        let headerFrame = self.view.frame.size
        self.sectionLabel.frame = CGRect(x: 50, y: 10, width: headerFrame.width - 100, height: CGFloat.infinity)
        
        
        header.contentView.backgroundColor = AppColor.Shared.colorWhite
        
        header.textLabel?.textColor = AppColor.Shared.greyText
        
        header.textLabel?.font = AppFonts.Shared.Medium.withSize(15)
        
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
        viewWithTag.removeFromSuperview()
        }
        
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 15, width: 20, height: 20));
        theImageView.image = UIImage(named: "down-arrow")
        theImageView.tag = kHeaderSectionTag + section
        //theImageView.backgroundColor = AppColor.Shared.greylight
        let indexImageView = UIImageView(frame: CGRect(x: 18, y: 16, width: 18, height: 18));
        
        //indexImageView.tag = kHeaderSectionTag + section
        indexImageView.backgroundColor = AppColor.Shared.greylight
        indexImageView.image = UIImage(named: images[section])
//        let label = UILabel(frame: CGRect(x: 48, y: 10, width: headerFrame.width - 96, height: 30))
//
//
//        label.text = list[section].name
//        label.textColor = AppColor.Shared.greyText
//        label.font = AppFonts.Shared.Medium.withSize(15)
       // header.addSubview(label)
        header.contentView.addSubview(indexImageView)
        header.addSubview(theImageView)
       
        // make headers touchable
        header.tag = section
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
        
        
    }
    
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
    let headerView = sender.view as! UITableViewHeaderFooterView
    let section = headerView.tag
    let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
    
        
    if (self.expandedSectionHeaderNumber == -1) {
    self.expandedSectionHeaderNumber = section
        if section == 0 && self.expandedSectionHeaderNumber == 0{
            
        self.leadGenerationVm.leadWalkingCustomerRequestDetailsList()
            
        }
    tableViewExpandSection(section, imageView: eImageView!)
    } else {
    if (self.expandedSectionHeaderNumber == section) {
    tableViewCollapeSection(section, imageView: eImageView!)
    } else {
    let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
    tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
    tableViewExpandSection(section, imageView: eImageView!)
      }
    }
        
       
        
    }
    
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.list[section].list
    self.expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0) {
    return;
    } else {
    UIView.animate(withDuration: 0.4, animations: {
    imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
    })
    var indexesPath = [IndexPath]()
    for i in 0 ..< sectionData.count {
    let index = IndexPath(row: i, section: section)
    indexesPath.append(index)
    }
    self.leadGenerateTableView.beginUpdates()
        self.leadGenerateTableView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
    self.leadGenerateTableView.endUpdates()
    }
    }
    
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
    let sectionData = self.list[section].list
    if (sectionData.count == 0) {
    self.expandedSectionHeaderNumber = -1;
    return;
    } else {
    UIView.animate(withDuration: 0.4, animations: {
    imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
    })
    var indexesPath = [IndexPath]()
    for i in 0 ..< sectionData.count {
    let index = IndexPath(row: i, section: section)
    indexesPath.append(index)
    }
    self.expandedSectionHeaderNumber = section
    self.leadGenerateTableView.beginUpdates()
        self.leadGenerateTableView.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
    self.leadGenerateTableView.endUpdates()
    }
    }
    
    
    
    
    
}


@available(iOS 14, *)
extension LeadGenerationVC:PHPickerViewControllerDelegate{
    fileprivate func uploadedImageConvertToBarCodeString(_ image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            
            let barcodeOptions = BarcodeScannerOptions.init(formats: self.format)
            let images = VisionImage(image: image)
            self.visionImage = VisionImage.init(image: image)
            self.visionImage.orientation = images.orientation
            let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
            
            sleep(1)
            do {
                let barcodes = try barcodeScanner.results(in: images)
                let displayValue = barcodes.first?.displayValue ?? ""
                
                self.found(code: displayValue)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        UIView.animate(withDuration: 3, delay: 0) {
            self.previewLayer.removeFromSuperlayer()
            self.scannerBounds.removeFromSuperlayer()
            self.uploadButton?.removeFromSuperview()
            self.view.setBGColor(color: AppColor.Shared.colorWhite)
            self.view.subviews.map{ self.view.showViews(showView: $0) }

            self.dismiss(animated: true)
        }
            let itemProviders = results.map(\.itemProvider)
            for item in itemProviders {
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                     
                            if let image = image as? UIImage {
                                
                                uploadedImageConvertToBarCodeString(image)

                            }
                        
                    }
                }
            }}
    
    
}

extension LeadGenerationVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        UIView.animate(withDuration: 3, delay: 0) {
            self.previewLayer.removeFromSuperlayer()
            self.scannerBounds.removeFromSuperlayer()
            self.uploadButton?.removeFromSuperview()
            self.view.setBGColor(color: AppColor.Shared.colorWhite)
            self.view.subviews.map{ self.view.showViews(showView: $0) }

            self.dismiss(animated: true)
        }
      
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if #available(iOS 14, *) {
            uploadedImageConvertToBarCodeString(image)
        } else {
            // Fallback on earlier versions
        }
        
    }
}

extension LeadGenerationVC:UITextFieldDelegate{
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            
            
            let currentString : NSString = textField.text!  as NSString
            let searchString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            searchNameOrMobileText = searchString as String
            return searchString.length <= 20
        }
    
    
}


// ============================== PROTOCOL SECTION ==============================================

extension LeadGenerationVC:PincodeDelegate{
    func getPinCode(pincode: String) {
       
        let pin = Int(pincode.prefix(6))
        self.moreInfoPinCode = pin == nil ? "" : "\(pin!)"
        print("pin:\(self.moreInfoPinCode)")
        
        
    }
}

extension LeadGenerationVC:ProductModelDelegate{
    func getProductModel(model: String) {
        self.productModelString = model
        self.selectedProductDetailInfo.ModelString = self.productModelString
        print(self.selectedProductDetailInfo)
    }
    
}

extension LeadGenerationVC:ProductEnquiryDelegate{
    func getEnquiryText(text: String) {
        self.selectedProductDetailInfo.EnquiryText = text
        print(self.selectedProductDetailInfo)
    }
    
    
}

extension LeadGenerationVC : LeadLocationDelegate{
    func getLeadLocation(location: String, coordinates: (lat: Double, lon: Double),vc:UIViewController) {
        DispatchQueue.main.async {
           
            
            self.coordinates = coordinates
//            map.delegate = nil
//            map.removeFromSuperview()
            self.locationAddress = location
            let mapVC = AppVC.Shared.mapViewPage
            
            DispatchQueue.main.async {
                mapVC.gmsMapView = GMSMapView()
            }
            
            
    
            
        }
    }
    
    
}


extension LeadGenerationVC:QuantityDelegate{
    func maxQuantity(cell: ProjectProductDetailsTVC, qty: String) {
        if Int(qty) ?? 0 > 12{
            self.popupAlert(title: "", message: "Quantity cannot exceed 12", actionTitles: [closeTitle], actions: [{action1 in
                self.selectedProductDetailInfo.quantity = "0"
            },nil])
        }else{
            self.selectedProductDetailInfo.quantity = qty
        }
    }
    
    
}

extension LeadGenerationVC : ProjectDateDelegate{
    func projectDate(date: String) {
        self.selectedProductDetailInfo.date = date
    }
    
    
}

extension LeadGenerationVC:LeadDetailsDateDelegate{
    func getDate(date: String) {
        self.leadDetailsDate = date
    }
    
    
}

extension LeadGenerationVC:AttendanceChangeProtocol{
    func changeAttendance(status: Bool) {
        self.punchStatus = status
        
        
    }
    
    
}

extension LeadGenerationVC:ExpectedDateProtocol{
    
    
    func expectedDateString(date: String) {
        
        
        expectedDateString = date
        self.selectedProductDetailInfo.expectedDateString = expectedDateString
        

    }

    
    
}

extension LeadGenerationVC:ProductOfferPriceDelegate{
    func getOfferPrice(value: String) {
        let mrp = self.selectedProductDetailInfo.MRP == "" ? "0.00" : self.selectedProductDetailInfo.MRP
        
        let offerPrice = value == "" ? "0.00" : value
        
        switch Int(mrp){
        case 0:
            self.selectedProductDetailInfo.Price = value
        default:
            if Double(mrp)! > Double(offerPrice)! {
                self.selectedProductDetailInfo.Price = value
            }else {
                
                if mrp != "0.00" {
                self.popupAlert(title: "", message: "Offer price cannot exceed MRP price", actionTitles: [closeTitle], actions: [{action1 in
                    self.selectedProductDetailInfo.Price = "0.00"
                },nil])
                }else{
                    self.selectedProductDetailInfo.Price = value
                }
                
            }
        }
        
        
    }
    
    
}


