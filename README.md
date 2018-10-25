# PBDropDown
Simple library to show dropdown with search option
<BR>PBDropDown is written in Swift 4.2.

## At a Glance
```
let dropdown = PBDropdown(frame: self.dropdownView.frame, sourceArray: self.arrData, direction: .Up)
```

## Getting Started

### Show Dropdown in your controller 

```
let dropdown = PBDropdown()
dropdown.dropDownDelegate = self
dropdown.show(vc : self, anchorView: sender, sourceArray: ["one","two"], direction: .Up, isSearch: true)
```

### Required Delegate Method
```
func didSelectDropDown(_ index:Int,_ data:Any)
```
