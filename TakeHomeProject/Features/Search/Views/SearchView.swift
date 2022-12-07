//
//  SearchView.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 13/09/2021.
//

import UIKit
import Combine

/// A view which allows for users to search for media
final class SearchView: UIViewController {
  
  // MARK: - Properties
  
  /// The ViewModel backing this view
  var viewModel: SearchViewModel?
  
  private var textField: PaddedTextField!
  private var searchButton: UIButton!
  private var tableView: UITableView!
  private var noRecentSearchesImageView: UIImageView!
  private var noRecentSearchesTitle: UILabel!
  private var noRecentSearchesSubtitle: UILabel!
  private let reuseId = "reuseId"
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    view.backgroundColor = .backGroundColour
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.title = "SEARCH"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchButton.isEnabled = true
    tableView.reloadData()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    textField = PaddedTextField()
    textField.delegate = self
    textField.backgroundColor = .systemGray6
    textField.layer.cornerRadius = 10.0
    textField.placeholder = "Photos & Videos..."
    view.addSubview(textField)
    
    searchButton = UIButton()
    searchButton.backgroundColor = .systemBlue
    searchButton.layer.cornerRadius = 10.0
    let searchButtonImage = UIImage(systemName: "magnifyingglass")
    searchButton.setImage(searchButtonImage, for: .normal)
    searchButton.imageView?.tintColor = .white
    searchButton.addTarget(viewModel, action: #selector(viewModel?.startSearch), for: .touchUpInside)
    view.addSubview(searchButton)
    
    tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
    view.addSubview(tableView)
    
    let image = UIImage(named: "noRecentSearches")
    let templateImage = image?.withTintColor(.templateImageTint ?? .black)
    noRecentSearchesImageView = UIImageView()
    noRecentSearchesImageView.image = templateImage
    view.addSubview(noRecentSearchesImageView)
    
    noRecentSearchesTitle = UILabel()
    noRecentSearchesTitle.text = "Your recent searches will appear here..."
    noRecentSearchesTitle.font = .systemFont(ofSize: 15)
    noRecentSearchesTitle.textColor = .lightGray
    noRecentSearchesTitle.alpha = 0.55
    noRecentSearchesImageView.addSubview(noRecentSearchesTitle)
    
    noRecentSearchesSubtitle = UILabel()
    noRecentSearchesSubtitle.text = "You currently have no recent searches."
    noRecentSearchesSubtitle.font = .systemFont(ofSize: 14)
    noRecentSearchesSubtitle.textColor = .lightGray
    noRecentSearchesSubtitle.alpha = 0.55
    noRecentSearchesImageView.addSubview(noRecentSearchesSubtitle)
  }
  
  private func setupConstraints() {
    guard let viewModel = viewModel else { return }
    
    textField.anchor(
      top: view.safeAreaLayoutGuide.topAnchor,
      paddingTop: 20,
      leading: view.leadingAnchor,
      paddingLeft: 20,
      trailing: searchButton.leadingAnchor,
      paddingRight: 30,
      height: 40
    )
    
    searchButton.anchor(
      top: view.safeAreaLayoutGuide.topAnchor,
      paddingTop: 20,
      trailing: view.trailingAnchor,
      paddingRight: 25,
      width: 60,
      height: 40
    )
    
    noRecentSearchesImageView.contentMode = .scaleAspectFit
    noRecentSearchesImageView.anchor(
      leading: view.leadingAnchor,
      paddingLeft: 15,
      trailing: view.trailingAnchor,
      paddingRight: 20,
      centerY: view.safeAreaLayoutGuide.centerYAnchor
    )
    
    noRecentSearchesTitle.anchor(
      centerX: view.safeAreaLayoutGuide.centerXAnchor,
      centerY: view.safeAreaLayoutGuide.centerYAnchor,
      height: 20)
    
    noRecentSearchesSubtitle.anchor(
      top: noRecentSearchesTitle.bottomAnchor,
      paddingTop: 20,
      centerX: view.safeAreaLayoutGuide.centerXAnchor,
      height: 20
    )
    
    tableView.anchor(
      top: textField.bottomAnchor,
      paddingTop: 60,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      paddingLeft: 20,
      trailing: view.trailingAnchor,
      paddingRight: 20
    )
    
    viewModel.$recentSearchesIsEmpty
      .sink { [weak self] value in
        if value {
          self?.tableView.isHidden = true
          self?.noRecentSearchesImageView.isHidden = false
        } else {
          self?.tableView.isHidden = false
          self?.noRecentSearchesImageView.isHidden = true
        }
      }
      .store(in: &cancellables)
  }
}

// MARK: - UITableViewDelegate methods
extension SearchView: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    
    return viewModel.filteredSearches.isEmpty ? viewModel.recentSearches.count : viewModel.filteredSearches.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
    cell.backgroundColor = .clear
    if viewModel.filteredSearches.isEmpty {
      cell.textLabel?.text = viewModel.recentSearches[indexPath.row].searchTitle
    } else {
      cell.textLabel?.text = viewModel.filteredSearches[indexPath.row].searchTitle
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel else { return }
    
    if viewModel.filteredSearches.isEmpty {
      let selectedSearch = viewModel.recentSearches[indexPath.row]
      viewModel.navigateToGallery(with: selectedSearch)
    } else {
      let selectedSearch = viewModel.filteredSearches[indexPath.row]
      viewModel.navigateToGallery(with: selectedSearch)
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerLabel = UILabel()
    headerLabel.text = "Recent searches"
    headerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    headerLabel.backgroundColor = .backGroundColour
    return headerLabel
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard let viewModel = self.viewModel,
          viewModel.filteredSearches.isEmpty else { return nil }
    let deleteAction = UIContextualAction(style: .destructive,
                                          title: "delete",
                                          handler: { (action,
                                                      view,
                                                      completionHandler) in
                                            self.viewModel?.recentSearches.remove(at: indexPath.row)
                                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                                            completionHandler(true)
                                          })
    deleteAction.image = UIImage(systemName: "xmark.bin.fill")
    deleteAction.backgroundColor = .systemRed
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
}

// MARK: - UITextFieldDelegate methods

extension SearchView: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text,
          !(text + string).contains("\n") else { return false }
    if string.isEmpty {
      viewModel?.currentQuery = String(text.dropLast())
      viewModel?.filterSearch()
    } else {
      viewModel?.currentQuery = text + string
      viewModel?.filterSearch()
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    textField.resignFirstResponder()
    viewModel?.currentQuery = text
    viewModel?.startSearch()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    viewModel?.currentQuery = text
  }
}

// MARK: - SearchQueryDelegate methods
extension SearchView: SearchQueryDelegate {
  
  func listHasChanged() {
    tableView.reloadData()
  }
  
  func clearTextField() {
    textField.text = ""
  }
  
  func searchHasBegan() {
    searchButton.isEnabled = false
  }
}
