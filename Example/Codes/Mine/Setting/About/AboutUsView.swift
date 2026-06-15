//
//  AboutUsView.swift
//  XMSport
//
//  Created by moonShadow on 2024/4/23
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

protocol AboutUsViewDelegate: AnyObject {
    
    func listItemEvent(_ data: DTB.CellData)
}

///
class AboutUsView: UIView {
    
    weak var delegate: AboutUsViewDelegate?
    
    private var sections: [DTB.SectionModel] = []
    
    func updateSection(_ data: [DTB.SectionModel]) {
        self.sections = data
        tableView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
        
        // logo.kf.setImage(with: URL(string: ""))
        
        self.backgroundColor = .dtb.create("bg")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .dtb.create("bg")
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(logo)
        box.addSubview(nameLabel)
        box.addSubview(versionLabel)
        box.addSubview(tableView)
        box.addSubview(buildLabel)
        
        logo.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(box.snp.top).offset(24.0)
            make.width.height.equalTo(80.0.dtb.hf())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(logo.snp.bottom).offset(16.0)
        }
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(24.0)
            make.left.equalTo(box.snp.left).offset(0)
            make.right.equalTo(box.snp.right).offset(-0)
            make.bottom.equalTo(box.safeAreaLayoutGuide.snp.bottom).offset(-8.0)
        }
        buildLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.bottom.equalTo(box.snp.bottom).offset(-16.0)
        }
    }
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 10.0
        return logo
    }()
    
    private lazy var nameLabel = UILabel().dtb.textStyle("large02").text(DTB.app.displayName).value
    
    private lazy var versionLabel = UILabel().dtb.textStyle("detail02").text(DTB.app.version).value
    
    private lazy var tableView = UITableView.dtb.plain(self, cells: [DTB.ITDIArrowTableViewCell.self])
    
    private lazy var buildLabel = UILabel().dtb.textStyle("detail02").text(DTB.app.build).value
}

extension AboutUsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data else {
            return
        }
        delegate?.listItemEvent(data)
    }
}

extension AboutUsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.dtb[section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.ITDIArrowTableViewCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        if let model = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row] {
            cell.update(model)
        }
        return cell
    }
}
