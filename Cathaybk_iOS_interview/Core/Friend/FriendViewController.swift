//
//  FriendViewController.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit
import RxSwift
import RxCocoa

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
    var tableViewTopConstraint1: NSLayoutConstraint?
    var tableViewTopConstraint2: NSLayoutConstraint?
    var selectFilterViewTopConstraint1: NSLayoutConstraint?
    var selectFilterViewTopConstraint2: NSLayoutConstraint?

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

        style()
        layout()
        setupTableView()
        setupCardContainer()
        
        bind()
        
        viewModel.fetchUserData()
        viewModel.fetchFriendData(scenario: self.scenario)
        
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Bind
    private func bind() {
        
        // 搜索结果数据
        let searchResults = searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                query.isEmpty
                ? self.viewModel.friendElements.asObservable()
                : self.viewModel.searchFriends(query: query)
            }
            .share(replay: 1)
        
        // 根据搜索栏的状态决定展示数据
        Observable.combineLatest(viewModel.friendElements, searchResults, searchController.searchBar.rx.text.orEmpty) { friendElements, searchResults, query in
            return query.isEmpty ? friendElements : searchResults
        }
        .bind(to: tableView.rx.items(cellIdentifier: FriendTableViewCell.identifier, cellType: FriendTableViewCell.self)) { (row, item, cell) in
            cell.friendElement = item
        }
        .disposed(by: disposeBag)
        
        
        // 配置搜索控制器的状态变化
        searchController.searchBar.rx.text.orEmpty
            .bind(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.friendElements
            .asDriver() // 将 Observable 转换为 Driver 单元，它会确保在主线程上执行，并且正确地处理错误。
            .drive(onNext: { [weak self] friendElements in
                let isEmpty = friendElements.isEmpty
                self?.tableView.backgroundView?.isHidden = !isEmpty
                if !isEmpty {
                    self?.inviteContainer.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        // 监听搜索栏的激活状态
        searchController.rx.didPresent
            .subscribe(onNext: { [unowned self] _ in
                print("searchController.rx.didPresent")
                
                self.viewVisible(visible: true)
            })
            .disposed(by: disposeBag)
        
        // 监听搜索栏的取消按钮点击事件
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [unowned self] _ in
                // 处理搜索取消的逻辑
                print("searchController.searchBar.rx.cancelButtonClicked")
                
                self.viewVisible(visible: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.userElement
            .asObservable()
            .subscribe(onNext: { [weak profileView = self.profileView] element in
                profileView?.configure(userData: element.first)
            })
            .disposed(by: disposeBag)
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
//        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
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
        
        //Setup refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中..")
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }
    
    func layout() {
        
        configureNavbar()
        view.addSubview(profileView)
        view.addSubview(inviteContainer)
        view.addSubview(selectFilterView)
        view.addSubview(separatorView!)
        view.addSubview(tableView)
//        tableView.addSubview(addFriendButton)
        tableView.tableHeaderView = searchController.searchBar
        
        inviteContainerHeightConstraint = inviteContainer.heightAnchor.constraint(equalToConstant: 70)
        
        tableViewTopConstraint1 = tableView.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor, constant: 0.5)
        tableViewTopConstraint1?.isActive = true
        
        tableViewTopConstraint2 = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
                
        NSLayoutConstraint.activate([
            
            profileView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            profileView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: profileView.trailingAnchor, multiplier: 3),
            
            inviteContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            inviteContainer.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 35),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: inviteContainer.trailingAnchor, multiplier: 3),
            
            inviteContainerHeightConstraint!,
            
            selectFilterView.topAnchor.constraint(equalTo: inviteContainer.bottomAnchor, constant: 32),
            selectFilterView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: selectFilterView.trailingAnchor, multiplier: 3),
            
            separatorView!.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor),
            separatorView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView!.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView!.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            tableViewTopConstraint1!,
                        
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                        
            tableView.backgroundView!.topAnchor.constraint(equalTo: selectFilterView.bottomAnchor, constant: 0.5),
            tableView.backgroundView!.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.backgroundView!.trailingAnchor, multiplier: 3),
            tableView.backgroundView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            tableView.tableHeaderView!.topAnchor.constraint(equalTo: tableView.topAnchor),
//            tableView.tableHeaderView!.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
//            tableView.tableHeaderView!.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
//            
//            searchController.searchBar.leadingAnchor.constraint(equalTo: tableView.tableHeaderView!.leadingAnchor),
//            searchController.searchBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            
//            searchController.searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
//            addFriendButton.centerYAnchor.constraint(equalTo: searchController.searchBar.centerYAnchor),
//            addFriendButton.leadingAnchor.constraint(equalTo: searchController.searchBar.trailingAnchor, constant: 10),
//            addFriendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            addFriendButton.widthAnchor.constraint(equalToConstant: 24),
//            addFriendButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
//        tableView.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
//        tableView.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
    
    func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//        tableView.rx.setDataSource(self).disposed(by: disposeBag)
//        tableView.delegate = self
//        tableView.dataSource = self
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
        print("withdrawButtonTapped")
    }
    
    @objc func transferButtonTapped() {
        print("transferButtonTapped")
    }
    
    @objc func scanButtonTapped() {
        print("scanButtonTapped")
    }
    
    @objc func addFriendHandler() {
        print("add friend button is pressed")
    }
    
    @objc func refreshHandler() {
        print("refreshHandler")
        //延遲0.5秒
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [self] in
            viewModel.fetchFriendData(scenario: self.scenario)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func viewVisible(visible: Bool) {
        
        tableViewTopConstraint1!.isActive = !visible
        tableViewTopConstraint2!.isActive = visible
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - 表視圖
extension FriendViewController : UITableViewDelegate, UITableViewDataSource {
    
    //RxSwift不觸發此函式
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        if viewModel.friendElements.value.count > 0 {
//            tableView.backgroundView?.isHidden = true
//            addFriendButton.isHidden = false
//            tableView.tableHeaderView?.isHidden = false
//        } else {
//            addFriendButton.isHidden = true
//            tableView.backgroundView?.isHidden = false
//            tableView.tableHeaderView?.isHidden = true
//        }
//
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //RxSwift不觸發此函式
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return viewModel.friendElements.value.count
        }
    }
    
    //RxSwift不觸發此函式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
                        
        //cell顯示內容:搜尋結果 or 原內容
        cell.friendElement = (searchController.isActive) ? searchResults[indexPath.row] : viewModel.friendElements.value[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選取時此列會以灰色來突出顯示，並保持在被選取狀態
        //加入取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
//MARK: - 邀請卡片容器
extension FriendViewController: CardContainerDataSource, CardContainerDelegate {
    
    func numberOfCardsToShow() -> Int {
                
        let num = viewModel.friendElements.value.filter {
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
                        
        let invite = viewModel.friendElements.value.filter {
            $0.status == .inviting
        }
        
        let card = InviteCardView()
        card.nameLabel.text = invite[index].name
        card.profileImage.updateImage(name: invite[index].name)
        
        return card
    }
    
    func findFriendElement(withName name: String) -> [FriendElement] {
        let filteredElements = viewModel.friendElements.value.filter { $0.name.contains(name) }
        return filteredElements
    }
    
    //回覆邀請的處理函式
    func card(_ view: InviteCardView, at index: Int) {
        
        //如果邀請列沒有邀請就隱藏
        if inviteContainer.numberOfVisibleCards < 1 {
            inviteContainer.isHidden = true
        }
        
        if let indexInFriendElements = viewModel.friendElements.value
            .firstIndex(where: { $0.name == view.nameLabel.text }) {
            
            //將該名字的狀態更新
            var updatedFriendElements = viewModel.friendElements.value
            updatedFriendElements[indexInFriendElements].status = .invited
            viewModel.friendElements.accept(updatedFriendElements)
            self.tableView.reloadData()
        }
    }
    
    func cardContainer(didSelect view: InviteCardView, at index: Int) {
        print("Card at index \(index) was selected")
    }
    
    func cardContainer(willDisplay view: InviteCardView, at index: Int) {
        print("Card at index \(index) was added into container")
    }
}

//MARK: - UIScrollView
extension FriendViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        print("current y：\(offsetY)")
    }
}
