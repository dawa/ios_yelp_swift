//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Davis Wamola on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersViewController: FiltersViewController,
                                              didUpdateFilters filters: YelpFilters)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var model: YelpFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new instance of the model for this "session"
        self.model = YelpFilters(instance: YelpFilters.instance)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        // Customize Navigation Bar
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor.red
            navigationBar.tintColor = UIColor.white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        YelpFilters.instance.copyStateFrom(instance: self.model!)
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: self.model!)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model!.filters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = self.model!.filters[section]
        if !filter.opened {
            if filter.type == FilterType.Single {
                return 1
            } else if filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count {
                return filter.numItemsVisible! + 1
            }
        }
        return filter.options.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.model!.filters[section]
        let label = filter.label
        
        // Add the number of selected options for multiple-select filters with hidden options
        if filter.type == .Multiple && filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count && !filter.opened {
            let selectedOptions = filter.selectedOptions
            return "\(label) (\(selectedOptions.count) selected)"
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        let filter = self.model!.filters[indexPath.section]
        switch filter.type {
        case .Single:
            if filter.opened {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "checked"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "unchecked"))
                }
            } else {
                cell.textLabel?.text = filter.options[filter.selectedIndex].label
                cell.accessoryView = UIImageView(image: UIImage(named: "dropdown"))
            }
        case .Multiple:
            if filter.opened || indexPath.row < filter.numItemsVisible! {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "checked"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "unchecked"))
                }
            } else {
                cell.textLabel?.text = "See All"
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.textLabel?.textColor = .darkGray
            }
        default:
            let option = filter.options[indexPath.row]
            cell.textLabel?.text = option.label
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let switchView = Switch(thumb: SwitchThumb(), background: SwitchBackground()) //Custom switch
            switchView.isOn = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: #selector(self.switchValueChanged), for: UIControlEvents.valueChanged)
            cell.accessoryView = switchView
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = self.model!.filters[indexPath.section]
        switch filter.type {
        case .Single:
            if filter.opened {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = IndexPath(item: previousIndex, section: indexPath.section)
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath], with: .automatic)
                }
            }

            let opened = filter.opened;
            filter.opened = !opened;

            if opened {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }
            } else {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            }
        case .Multiple:
            if !filter.opened && indexPath.row == filter.numItemsVisible {
                filter.opened = true
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            } else {
                let option = filter.options[indexPath.row]
                option.selected = !option.selected
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }

    func switchValueChanged(switchCell: UISwitch, didChangeValue value: Bool) {
        let cell = switchCell.superview as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let filter = self.model!.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchCell.isOn
        }
    }
}
