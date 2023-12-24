//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit

protocol FollowersListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowersListVC: UIViewController {
    
    enum Section { case main }  //hashable by default
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        confiureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped(){
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func confiureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search a user"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page: Int) {
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case.success(let followersList):
                if followersList.count < 99 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followersList)
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
                self.updateData(on: self.followers)
                
            case.failure(let error):
                self.presentGFAlertAndPopVCOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Return")
            }
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}


extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offSetY > contentHeight - height {
            guard hasMoreFollowers, !isSearching else {return}
            page+=1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = (isSearching ? filteredFollowers : followers)[indexPath.item]
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        userInfoVC.delegate = self // so that is listening to the userInfoVC
        let navController = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
}


extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(on: followers)
            return
        }
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { isSearching = true }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { isSearching = false }
}

extension FollowersListVC: FollowersListVCDelegate{
    func didRequestFollowers(for username: String) {
    
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
    
}
