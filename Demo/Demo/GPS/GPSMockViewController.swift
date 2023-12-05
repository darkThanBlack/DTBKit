//
//  GPSMockViewController.swift
//  Demo
//
//  Created by moonShadow on 2023/12/5
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import MapKit
import SnapKit

///GPSMock
class GPSMockViewController: UIViewController {
    
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadViews(in: view)
    }
    
    @objc private func removeButtonEvent(button: UIButton) {
        GPSCheckInManager.shared.stopMonitor()
    }
    
    enum FieldKeys: String {
        case enter_latitude, enter_longitude, enter_radius
    }
    
    class CreatingModel {
        var lati: CLLocationDegrees
        var longi: CLLocationDegrees
        var radius: CLLocationDistance
        
        var isEmpty: Bool {
            return [lati, longi, radius].contains(where: { $0 <= 0 })
        }
        
        init(lati: CLLocationDegrees, longi: CLLocationDegrees, radius: CLLocationDistance) {
            self.lati = lati
            self.longi = longi
            self.radius = radius
        }
    }
    
    private var creating: CreatingModel?
    
    @objc private func addButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "添加围栏", message: "圆形: 经纬度+半径", preferredStyle: .alert)
        creating = CreatingModel(lati: 0, longi: 0, radius: 0)
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_latitude.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_longitude.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_radius.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            self.creating = nil
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            guard let model = self.creating, model.isEmpty == false else {
                self.creating = nil
                return
            }
            GPSCheckInManager.shared.addMonitor(lati: model.lati, longi: model.longi, radius: model.radius)
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: model.lati, longitude: model.longi), latitudinalMeters: model.radius, longitudinalMeters: model.radius)
            self.mapView.setRegion(region, animated: true)
            self.mapView.setCenter(region.center, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChanged(_ notification: Notification) {
        guard let field = notification.object as? UITextField,
              let value = Double(field.text ?? ""),
              let key = FieldKeys(rawValue: field.placeholder ?? "") else {
            return
        }
        switch key {
        case .enter_latitude:
            creating?.lati = value
        case .enter_longitude:
            creating?.longi = value
        case .enter_radius:
            creating?.radius = value
        }
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(box)
        }
    }
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        addButton.backgroundColor = .green
        addButton.setTitle("add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonEvent(button:)), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var removeButton: UIButton = {
        let removeButton = UIButton(type: .custom)
        removeButton.backgroundColor = .green
        removeButton.setTitle("remove", for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonEvent(button:)), for: .touchUpInside)
        return removeButton
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .hybrid
        view.userTrackingMode = .followWithHeading
        view.showsCompass = true
        view.showsScale = true
        view.showsUserLocation = true
        return view
    }()
    
    
}

