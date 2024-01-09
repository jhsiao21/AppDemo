//
//  FriendViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class FriendViewController: UIViewController {
    var scenario : Scenario
    var viewModel = FriendTableViewModel()
    let vStackView = UIStackView()
    let profileView =  ProfileView()
    var inviteContainer = InviteContainer()
    let selectFilterView = SelectedFilterView()
    let emptyView = EmptyView()
    var separatorView : UIView?
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var addFriendButton = UIButton()
    var searchResults: [FriendElement] = []
    var refreshControl = UIRefreshControl()
    var inviteContainerHeightConstraint: NSLayoutConstraint?

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    init(for scenario: Scenario) {
        self.scenario = scenario
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FriendTableViewModel()
        style()
        layout()
        setupTableView()
        setupCardContainer()
        
        Task{ await fetchUserData() }
        Task{
            fetchFriendData(scenario: self.scenario)
        }
    }
    
    override func viewDidLayoutSubviews() {
#if DEBUG
        print("viewDidLayoutSubviews")
#endif
    }
    
    func style() {
        
        view.backgroundColor = .white
        
        vStackView.axis = .vertical
        vStackView.backgroundColor = UIColor.backgroundWhite
        vStackView.spacing = 35
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        inviteContainer.translatesAutoresizingMaskIntoConstraints = false
        inviteContainer.delegate = self
        
        selectFilterView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0.5))
        separatorView?.translatesAutoresizingMaskIntoConstraints = false
        separatorView?.backgroundColor = UIColor.systemGray3
        
        addFriendButton = UIButton()
        addFriendButton.setImage(UIImage(named: "icBtnAddFriends")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addFriendButton.addTarget(self, action: #selector(addFriendHandler), for: .touchUpInside)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup search controller
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "想轉一筆給誰呢？"
        searchController.searchBar.layer.borderColor = UIColor.white.cgColor
        searchController.searchBar.layer.borderWidth = 1
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.isTranslucent = false
        
        //Setup tableView
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.whiteThree
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        self.definesPresentationContext = true //true，點搜尋框會上推至navBar位置下方；false，點搜尋框會上推至最上方位置
        
        //Setup refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中..")
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }
    
    func layout() {
        
        configureNavbar()
        vStackView.addArrangedSubview(profileView)
        vStackView.addArrangedSubview(inviteContainer)
        vStackView.addArrangedSubview(selectFilterView)
        view.addSubview(vStackView)
        view.addSubview(separatorView!)
        view.addSubview(tableView)
        tableView.addSubview(addFriendButton)
        tableView.tableHeaderView = searchController.searchBar
        
        inviteContainerHeightConstraint = inviteContainer.heightAnchor.constraint(equalToConstant: 70)
                
        NSLayoutConstraint.activate([
            
            vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            profileView.topAnchor.constraint(equalToSystemSpacingBelow: vStackView.topAnchor, multiplier: 2),
            profileView.leadingAnchor.constraint(equalToSystemSpacingAfter: vStackView.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: profileView.trailingAnchor, multiplier: 3),
            
            inviteContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: vStackView.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: inviteContainer.trailingAnchor, multiplier: 3),
            
            inviteContainerHeightConstraint!,
            
            selectFilterView.topAnchor.constraint(equalTo: inviteContainer.bottomAnchor, constant: 32),
            selectFilterView.leadingAnchor.constraint(equalToSystemSpacingAfter: vStackView.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: selectFilterView.trailingAnchor, multiplier: 3),
            
            separatorView!.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor),
            separatorView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView!.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView!.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            tableView.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor, constant: 0.5),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 3),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.backgroundView!.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor, constant: 0.5),
            tableView.backgroundView!.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.backgroundView!.trailingAnchor, multiplier: 3),
            tableView.backgroundView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.tableHeaderView!.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.tableHeaderView!.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            tableView.tableHeaderView!.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            
            searchController.searchBar.leadingAnchor.constraint(equalTo: tableView.tableHeaderView!.leadingAnchor),
            searchController.searchBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30),
            
            searchController.searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 30),
            
            addFriendButton.centerYAnchor.constraint(equalTo: searchController.searchBar.centerYAnchor),
            addFriendButton.leadingAnchor.constraint(equalTo: searchController.searchBar.trailingAnchor, constant: 10),
            addFriendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addFriendButton.widthAnchor.constraint(equalToConstant: 24),
            addFriendButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        tableView.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        tableView.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCardContainer() {
        inviteContainer.delegate = self
        inviteContainer.dataSource = self
    }
    
    private func configureNavbar() {
        navigationController?.navigationBar.backgroundColor = .backgroundWhite
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw"), style: .done, target: self, action: #selector(withdrawButtonTapped)),
            UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer"), style: .done, target: self, action: #selector(transferButtonTapped))
        ]
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icNavPinkScan"), style: .done, target: self, action: #selector(scanButtonTapped))
        ]
        navigationController?.navigationBar.tintColor = .hotPink
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func withdrawButtonTapped() {
#if DEBUG
        print("withdrawButtonTapped")
#endif
    }
    
    @objc func transferButtonTapped() {
#if DEBUG
        print("transferButtonTapped")
#endif
    }
    
    @objc func scanButtonTapped() {
#if DEBUG
        print("scanButtonTapped")
#endif
    }
    
    @objc func addFriendHandler() {
#if DEBUG
        print("add friend button is pressed")
#endif
    }
    
    @objc func refreshHandler() {
#if DEBUG
        print("add friend button is pressed")
#endif
        //延遲0.5秒
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [self] in
            fetchFriendData(scenario: self.scenario)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func fetchUserData() async {
        APIService.shared.fetchUserData { result in
            switch result {
            case .success(let data):
                self.profileView.configure(userData: data)
                
                DispatchQueue.main.async {
                    self.view.layoutIfNeeded()
                }
                
            case .failure(let error):
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
            }
        }
    }
    
    func fetchFriendData(scenario scene:Scenario) {
        
        switch scene {
        case .無好友畫⾯:
            request(with: Constants.Friend4)
        case .只有好友列表:
            fetchAndMergeFriendData { result in
                switch result {
                case .success(let data):
                    self.viewModel.friends = data

                    DispatchQueue.main.async {
                        self.tableView.reloadData()//friends資料用於更新tableView
                        self.inviteContainer.reloadData()//更新inviteContainer內容
                        
                        self.view.layoutIfNeeded()
                    }
                case .failure(let error):
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
                }
            }
        case .好友列表含邀請:
            request(with: Constants.Friend3)
        }
    }
    
    func request(with url: String) {
        APIService.shared.fetchFriendData(with: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
#if DEBUG
                print("fetchFriendData() success")
#endif
                self.viewModel.friends = data
                
                DispatchQueue.main.async {
#if DEBUG
                    print("inviteContainer:\(self.inviteContainer.numberOfVisibleCards)")
#endif
                    self.tableView.reloadData()//friends資料用於更新tableView
                    self.inviteContainer.reloadData()//更新cardContainer內容
                    self.view.layoutIfNeeded()
                }
            case .failure(let error):
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
            }
        }
    }
    
    func fetchAndMergeFriendData(completion: @escaping (Result<Friends, Error>) -> Void) {
        let group = DispatchGroup()
        var firstRequestResults: Friends?
        var secondRequestResults: Friends?
        var errors: [Error] = []
        // Merge the results
        var mergedResults: [String: FriendElement] = [:]
                
        group.enter()
        APIService.shared.fetchFriendData(with: Constants.Friend1) { [weak self] result in
            defer { group.leave() }
            guard let self = self else { return }
            switch result {
            case .success(let data):
                firstRequestResults = data
            case .failure(let error):
                completion(.failure(error))
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
            }
        }
        
        group.enter()
        APIService.shared.fetchFriendData(with: Constants.Friend2) { [weak self] result in
            guard let self = self else { return }
            defer { group.leave() }
            switch result {
            case .success(let data):
                secondRequestResults = data
            case .failure(let error):
                completion(.failure(error))
#if DEBUG
                print("Failed to fetch user data: \(error.localizedDescription)")
#endif
            }
        }
        
        
        // Once all requests have completed
        group.notify(queue: .main) {
            if !errors.isEmpty {
                // If there were any errors, return the first one
                completion(.failure(errors.first!))
                return
            }
            
            // Helper function to merge friends data
            func merge(friends: Friends) {
                for friend in friends.response {
                    // If the friend is already present, compare updateDate
                    if let existingFriend = mergedResults[friend.fid],
                        let newDate = Int(friend.updateDate.replacingOccurrences(of: "/", with: "")),
                       let existingDate = Int(existingFriend.updateDate.replacingOccurrences(of: "/", with: ""))
                    {
                        if newDate > existingDate {
                            mergedResults[friend.fid] = friend
                        }
                    } else {
                        mergedResults[friend.fid] = friend
                    }
                }
            }
            
            // Merge data from the first request
            if let firstResults = firstRequestResults {
                merge(friends: firstResults)
            }
            
            // Merge data from the second request
            if let secondResults = secondRequestResults {
                merge(friends: secondResults)
            }

            // 將字典中的 values 取出轉換為 [FriendElement]
            let friendElementsArray: [FriendElement] = Array(mergedResults.values)

            // 使用這個 [FriendElement] 建立一個新的 Friends 物件
            let friends: Friends = Friends(response: friendElementsArray)
            
            completion(.success(friends))
        }
    }
}

// MARK: - 表視圖
extension FriendViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if viewModel.friendElements.count > 0 {
            tableView.backgroundView?.isHidden = true
            addFriendButton.isHidden = false
            tableView.tableHeaderView?.isHidden = false
        } else {
            addFriendButton.isHidden = true
            tableView.backgroundView?.isHidden = false
            tableView.tableHeaderView?.isHidden = true
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return viewModel.friendElements.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
                        
        //cell顯示內容:搜尋結果 or 原內容
        cell.friendElement = (searchController.isActive) ? searchResults[indexPath.row] : viewModel.friendElements[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選取時此列會以灰色來突出顯示，並保持在被選取狀態
        //加入取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - 搜尋
extension FriendViewController : UISearchResultsUpdating, UISearchBarDelegate {
        
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

    func filterContent(for searchText: String) {
                
        if searchText.isEmpty
        {
            searchResults = viewModel.friendElements
        }else {
            searchResults = viewModel.friendElements.filter {
                $0.name.contains(searchText)
            }
        }
//        print(searchResults)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
#if DEBUG
        print("searchBarSearchButtonClicked")
#endif
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
#if DEBUG
        print("searchBarShouldBeginEditing")
#endif
        
        viewVisible(visible: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
#if DEBUG
        print("searchBarCancelButtonClicked")
#endif
        
        viewVisible(visible: false)
        
        //邀請列表顯示條件
        if inviteContainer.numberOfVisibleCards < 1 {
            //邀請列表內沒有邀請情況下按searchBar的cancel
            inviteContainer.isHidden = true
            inviteContainer.alpha = 0
        }else {
            //邀請列表內有邀請情況下按searchBar的cancel
            inviteContainer.isHidden = false
            inviteContainer.alpha = 1
        }
    }
    
    private func viewVisible(visible: Bool) {
        let alpha = visible ? 0 : 1.0
        vStackView.isHidden = visible
        vStackView.alpha = alpha
        profileView.isHidden = visible
        profileView.alpha = alpha
        inviteContainer.isHidden = visible
        inviteContainer.alpha = alpha
        selectFilterView.isHidden = visible
        selectFilterView.alpha = alpha
        separatorView!.isHidden = visible
        separatorView!.alpha = alpha
        addFriendButton.isHidden = visible
        addFriendButton.alpha = alpha
        tableView.tableHeaderView?.isHidden = visible
        tableView.refreshControl!.isEnabled = !visible
    }
}

//MARK: - 邀請卡片容器
extension FriendViewController: CardContainerDataSource, CardContainerDelegate {
    
    func numberOfCardsToShow() -> Int {
//        return viewModel?.invitingFriends.count ?? 0
                
        let num = viewModel.friendElements.filter {
            $0.status == .inviting
        }.count
        
        if num > 0 {
            inviteContainer.isHidden = false
        } else {
            inviteContainer.isHidden = true
        }
        
        return num
        
    }
    
    func card(at index: Int) -> InviteCardView? {
                        
        let invite = viewModel.friendElements.filter {
            $0.status == .inviting
        }
        
        let card = InviteCardView()
        card.nameLabel.text = invite[index].name
        card.thumbnailImageView.updateImage(name: invite[index].name)
        
        return card
    }
    
    func findFriendElement(withName name: String) -> [FriendElement] {
        let filteredElements = viewModel.friendElements.filter { $0.name.contains(name) }
        return filteredElements 
    }
    
    //回覆邀請的處理函式
    func card(_ view: InviteCardView, at index: Int) {
//        print("inviteContainer:\(inviteContainer.numberOfVisibleCards)")
        
        //如果邀請列沒有邀請就隱藏
        if inviteContainer.numberOfVisibleCards < 1 {
            inviteContainer.isHidden = true
        }
        
        //更新表視圖資料
        //依據idx找到tableView資料源的名字
        let idx = viewModel.friendElements.firstIndex { $0.name == view.nameLabel.text }
        //將將該名字的狀態更新
        viewModel.friendElements[idx!].status = .invited
        //更新表視圖
        self.tableView.reloadData()
    }
    
//    func cardContainer(didShrink view: InviteCardView) {
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
//            self.inviteContainerHeightConstraint?.constant = 80
//            self.view.layoutIfNeeded()
//        })
//    }
//    
//    func cardContainer(didExpand view: InviteCardView) {
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
//            self.inviteContainerHeightConstraint?.constant = 150
//            self.view.layoutIfNeeded()
//        })
//    }
    
    func cardContainer(didSelect view: InviteCardView, at index: Int) {
#if DEBUG
        print("Card at index \(index) was selected")
#endif
    }
    
    func cardContainer(willDisplay view: InviteCardView, at index: Int) {
#if DEBUG
        print("Card at index \(index) was added into container")
#endif
    }
}

//MARK: - UIScrollView
extension FriendViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
#if DEBUG
//        print("current y：\(offsetY)")
#endif
    }
}
