//
//  RxLocationPermission.swift
//  RxLocationPermission
//
//  Created by Marcus Kida on 29.07.18.
//  Copyright © 2018 Marcus Kida. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

public class RxLocationPermission: NSObject {
    let locationManager = CLLocationManager()
    let subject = PublishSubject<CLAuthorizationStatus>()
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
}

extension RxLocationPermission: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !subject.isDisposed {
            subject.onNext(status)
            subject.onCompleted()
        }
    }
}

public extension Reactive where Base: CLLocationManager {
    public func requestAlwaysAuthorization() -> Observable<CLAuthorizationStatus> {
        let rxLocationPermission = RxLocationPermission()
        rxLocationPermission.locationManager.requestAlwaysAuthorization()
        return rxLocationPermission.subject.asObservable()
    }
    
    public func requestWhenInUseAuthorization() -> Observable<CLAuthorizationStatus> {
        let rxLocationPermission = RxLocationPermission()
        rxLocationPermission.locationManager.requestWhenInUseAuthorization()
        return rxLocationPermission.subject.asObservable()
    }
}
