//
//  ViewController.swift
//  ToDoApp
//
//  Created by 노민우 on 2023/05/11.
//

import UIKit

// 1. 폴더 구조잡기
// 2. 스토리보드 오토레이우웃 잡기
// 3. TableView, Cell 구성

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // 모델(저장 데이터를 관리하는 코아데이터)
    let toDoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupNaviBar()
        setupTableView()
    }

    // 화면에 다시 진입할때 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // tableView reloadData
        tableView.reloadData()
    }
    
    func setupNaviBar() {
        super.title = Names.NaviBarTitle
        
        // 내비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        // 내비게이션바 오른쪽 버튼 item 자리에 위치시키기 위하여 작성
        navigationItem.rightBarButtonItem = plusButton
    }
    
    func setupTableView() {
        tableView.dataSource = self
        // 테이블뷰 선 없애기
        tableView.separatorStyle = .none
    }
    
    @objc func plusButtonTapped() {
        // performSegue 실행할 코드 작성할거임
        performSegue(withIdentifier: Names.CellName, sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    // CoreData 에서 데이타를 가져와 셋팅을 해줘야하기때문에 코어데이터 부터 만들어야한다.
    // 1. Cell 만들기
    // 2. CoreDataManager 만들기
    
    // cell의 개수 표현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoManager.getToDoListFromCoreData().count
    }
    
    // (세그웨이를 실행할때) 실제 데이터 전달 (ToDoData 전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Names.CellName {
            let datailVC = segue.destination as! DetailViewController
            
            guard let indexPath = sender as? IndexPath else {return}
            datailVC.toDoData = toDoManager.getToDoListFromCoreData()[indexPath.row]
        }
    }
    
    // cell의 data전달
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Names.CellName, for: indexPath) as! ToDoCell
        // 셀 모델 (ToDoData) 전달
        let toDoData = toDoManager.getToDoListFromCoreData()
        cell.toDoData = toDoData[indexPath.row]
        
        // 셀 위에있는 버튼이 눌렸을때 (ViewController) 어떤 행동을 하기 위해서 클로저 전달
        cell.updateButtonPressed = { [weak self] (SenderCell) in
            // 뷰컨트롤러에 있는 세그웨이의 실행
            self?.performSegue(withIdentifier: Names.CellName, sender: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // 테이블 뷰의 높이를 자동적으로 추정하도록 하는 메서드
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let toDoDate = toDoManager.getToDoListFromCoreData()[indexPath.row]
            toDoManager.deleteToDo(data: toDoDate) {
                tableView.reloadData()
            }
            print(toDoManager.getToDoListFromCoreData())
        }
    }
}

