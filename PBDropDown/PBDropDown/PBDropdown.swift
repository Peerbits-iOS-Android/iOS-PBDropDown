//
//  PBDropdown.swift
//  test
//
//  Created by Tej on 25/10/18.
//  Copyright © 2018 Peerbits. All rights reserved.
//

// TODO:- let dropdown = PBDropdown(frame: self.dropdownView.frame, sourceArray: self.arrData, direction: .Up) -
//  TODO:- dropdown.dropDownDelegate = self -
//  TODO:- self.view.addSubview(dropdown)
//  TODO:- self.view.layoutIfNeeded()



import UIKit


//MARK:- Delegate Protocol -
public protocol PBDropdownDelegate {
    func didSelectDropDown(_ index:Int,_ data:Any)
}

public class PBDropdown: UIView {
    
    var tblDropdown = UITableView()
    var dropdown : PBDropdown!
    var arrData:[Any] = []
    public var dropDownDelegate:PBDropdownDelegate?
    var tblHeight : CGFloat = 0.0
    var tblWidth : CGFloat = 0.0
    var button = UIButton()
    var txtfield = UITextField()
    var lblNoData = UILabel()
    
    var isSearch = false
    
    var filterArray:[Any] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame:CGRect,sourceArray:[Any],direction:Direction , isSearch : Bool) {
        super.init(frame: frame)
        self.frame = frame
        self.isSearch = isSearch
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        layer.borderWidth = 1.0
        let effect = UIBlurEffect(style: .dark)
        tblDropdown.separatorEffect = UIVibrancyEffect(blurEffect: effect)
        self.isUserInteractionEnabled = true
        self.arrData = sourceArray
        self.filterArray = sourceArray
        tblDropdown = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: tblHeight))
        tblDropdown.delegate = self
        tblDropdown.dataSource = self
        tblDropdown.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblDropdown.rowHeight = UITableView.automaticDimension
        tblDropdown.tableFooterView = UIView()
        
        tblDropdown.estimatedRowHeight = 40
        if self.arrData.count > 0
        {
            self.addSubview(tblDropdown)
            tblDropdown.reloadData()
            tblDropdown.layoutIfNeeded()
        }
        tblHeight = tblDropdown.contentSize.height
        tblWidth = tblDropdown.contentSize.width
        if tblHeight > 200
        {
            tblHeight = 200
        }
        if isSearch
        {
            tblHeight = tblHeight + 50
        }
        if tblWidth > (UIScreen.main.bounds.width - frame.origin.x - (frame.size.width - (UIScreen.main.bounds.width + frame.origin.x)))
        {
            tblWidth = UIScreen.main.bounds.width
        }
        if Direction.Up == direction && (frame.origin.y <= UIScreen.main.bounds.height/2)
        {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y - tblHeight, width: tblWidth, height: tblHeight)
        }
        else
        {
            self.frame = CGRect(x: 15, y: frame.origin.y + frame.size.height, width: tblWidth, height: tblHeight)
        }
        lblNoData.frame = CGRect(x: 2, y: 2, width: tblWidth-4, height: tblHeight)
        
        tblDropdown.frame = CGRect(x: 0, y: 0, width: tblWidth, height: tblHeight)
        
       
        
        
        lblNoData.isHidden = true
        lblNoData.text = "No Result Found!!"
        lblNoData.textAlignment = .center
        lblNoData.numberOfLines = 0
       
    }
    
    @objc func txtFieldChanged(sender : UITextField)
    {

        if sender.text ?? "" == ""
        {
            filterArray = arrData
            lblNoData.removeFromSuperview()
            lblNoData.isHidden = true
            tblDropdown.separatorStyle = .singleLine
            tblDropdown.reloadData()
            return
        }
        filterArray = arrData.filter({ (obj) -> Bool in
            (obj as? String)?.uppercased().contains(sender.text?.uppercased() ?? "") ?? false
        })
        if filterArray.count == 0
        {
            tblDropdown.separatorStyle = .none
            lblNoData.isHidden = false
            tblDropdown.addSubview(lblNoData)
        }
        else
        {
            lblNoData.removeFromSuperview()
            lblNoData.isHidden = true
            tblDropdown.separatorStyle = .singleLine
        }
        
        tblDropdown.reloadData()
    }
    
    
    func reloadData()
    {
        tblDropdown.reloadData()
    }
    
    //MARK:- Hide Dropdown -
    
    @objc func hideButton() {
        tblDropdown.removeFromSuperview()
        button.removeFromSuperview()
    }
    @objc func hideDropdown() {
        tblDropdown.removeFromSuperview()
        self.removeFromSuperview()
        button.removeFromSuperview()
    }
    
    
    
    //set direction to show Dropdown direction

    public func show(vc:UIViewController,anchorView:UIView,sourceArray:[Any],direction:Direction,isSearch : Bool)
    {
        self.isSearch = isSearch
        for viewController in vc.view.subviews
        {
            if viewController.isKind(of: PBDropdown.self)
            {
                return
            }
        }
        filterArray = sourceArray
        dropdown = PBDropdown(frame: anchorView.frame, sourceArray:sourceArray, direction: direction,isSearch:isSearch)
        dropdown.dropDownDelegate = vc as? PBDropdownDelegate
        vc.view.addSubview(dropdown)
        vc.view.bringSubviewToFront(dropdown)
    }
    
    
}

public enum Direction {
    case Up
    case Down
}

//MARK:- Tableview Delegate and DataSource -
extension PBDropdown : UITableViewDelegate,UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return isSearch ? 50.0 : 0.0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        txtfield = UITextField(frame: CGRect(x: 5, y: 2, width: tableView.frame.width-4, height: 45))
        txtfield.borderRect(forBounds: CGRect(x: 2, y: 2, width: tableView.frame.width-10, height: 45))
      
        txtfield.addTarget(self, action: #selector(self.txtFieldChanged), for: .editingChanged)
        txtfield.layer.cornerRadius = 15
        txtfield.placeholder = "Search"
        txtfield.clearButtonMode = .whileEditing
        header.addSubview(txtfield)
        header.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 41, width: tableView.frame.width, height: 1))
        view.backgroundColor = .lightGray
        header.addSubview(view)
        return header
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        if let tResult = self.filterArray[indexPath.row] as? String
        {
            cell.textLabel?.text = tResult
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.layoutIfNeeded()
        }
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        
        visualEffectView.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        
        cell.backgroundView?.addSubview(visualEffectView)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownDelegate?.didSelectDropDown(indexPath.row,self.arrData[indexPath.row])
        self.perform(#selector(hideDropdown), with: nil, afterDelay: 0.0)
        //self.hideDropdown()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
