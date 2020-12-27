//
//  ModalVC.swift
//  RemindersNavigationBar
//
//  Created by Peyton Shetler on 12/26/20.
//

import UIKit

class ModalVC: UITableViewController {

    // MARK: - Properties
    let rowHeight: CGFloat = 44
    let reuseIdentifier = "cellId"
    var dataSource: UITableViewDiffableDataSource<Section, Item>!

    var navBarFadeView: UIView?  // The view we'll be using to hide the nav bar

    

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        updateSnapshot()
        configureDataSource()
        configureTableView()
    }


    // MARK: - Navigation Bar
    func configureNavBar() {

        if let navBar = navigationController?.navigationBar, navBar.subviews.count > 0 {

            // Here we're setting the view's frame to be the same as the nav bar except we're adding one point to the height to account for the shadow image
            let frame = CGRect(
                x: 0,
                y: 0,
                width: self.navigationController!.navigationBar.frame.width,
                height: self.navigationController!.navigationBar.frame.height + 1
            )

            navBarFadeView = UIView(frame: frame)
            navBarFadeView!.backgroundColor = UIColor.systemGroupedBackground
            navBarFadeView!.translatesAutoresizingMaskIntoConstraints = false
            // The important part: we're inserting the fadeview into the _UIBarBackBackgrounds subviews at the 0 index.  This placement insures that nav bar buttons are still visible on top of the fading view 😎
            navBar.subviews[0].insertSubview(navBarFadeView!, at: 0)
        }

        self.title = "Fading Nav Bar!"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }


    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pointOfVisibility: CGFloat = -50.0 // The offset at which you want the nav bar to be visible
        let startingPoint: CGFloat = -56.0 // The offset when the scrollview is at rest

        let offset = scrollView.contentOffset.y // Offset

        let difference = startingPoint - offset // The difference (in points) between the point of rest and the offset
        let totalDifference: CGFloat = startingPoint - pointOfVisibility // The difference (in points) between the point of rest and the point of full visibility

        let percentage = abs((difference * 100) / totalDifference) // the percentage of the total difference

        let alpha = (100 - percentage) / 100  // the inverse of the previous percentage, set to an accepted value

        navBarFadeView!.alpha = alpha  // set the alpha of the fading view
    }
}


// MARK: - Tableview
extension ModalVC {
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)

            return cell
        }
    }


    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        for section in Section.allCases {
            snapshot.appendItems(section.items, toSection: section)
        }
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: false) }
    }


    func configureTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 8 : 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}


enum Section: CaseIterable {
    case sectionOne
    case sectionTwo
    case sectionThree

    var items: [Item] {
        switch self {
        case .sectionOne: return [.itemOne]
        case .sectionTwo: return [.itemTwo]
        case .sectionThree: return [.itemThree]
        }
    }
}

enum Item: CaseIterable {
    case itemOne
    case itemTwo
    case itemThree
}
