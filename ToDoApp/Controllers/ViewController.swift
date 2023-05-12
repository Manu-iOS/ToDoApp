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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    }
}

extension ViewController: UITableViewDataSource {
    
    // CoreData 에서 데이타를 가져와 셋팅을 해줘야하기때문에 코어데이터 부터 만들어야한다.
    // 1. Cell 만들기
    // 2. CoreDataManager 만들기
    
    // cell의 개수 표현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    // cell의 data전달
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

