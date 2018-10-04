//
//  Address.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import Foundation

class Address {
    
    private var _street: String!
    private var _city: String!
    private var _province: String!
    private var _postal: String!
    private var _country: String!
    private var _address: String!
    
    init() {
        self._street = ""
        self._city = ""
        self._province = ""
        self._postal = ""
        self._country = ""
        self._address = ""
    }
    
    init(street: String, city: String, province: String, postal: String, country: String) {
        self._street = street
        self._city = city
        self._province = province
        self._postal = postal
        self._country = country
        self._address = "\(street), \(city), \(province), \(postal), \(country)"
    }
    
    var street: String {
        get {
            return _street
        }
        set {
            _street = newValue
        }
    }
    
    var city: String {
        get {
            return _city
        }
        set {
            _city = newValue
        }
    }
    
    var province: String {
        get {
            return _province
        }
        set {
            _province = newValue
        }
    }
    
    var postal: String {
        get {
            return _postal
        }
        set {
            _postal = newValue
        }
    }
    
    var country: String {
        get {
            return _country
        }
        set {
            _country = newValue
        }
    }
    
    var address: String {
        get {
            return _address
        }
        set {
            _address = newValue
        }
    }
    
    func resetAddress() {
        self._address = "\(self._street!), \(self._city!), \(self._province!), \(self._postal!), \(self._country!)"
    }
    
    func isEmpty() -> Bool {
        if _street == "" && _city == "" && _province == "" && _postal == "" && _country == "" {
            return true
        } else {
            return false
        }
    }
    
    func isNotComplete() -> Bool {
        if _street == "" || _city == "" || _province == "" || _postal == "" || _country == "" {
            return true
        } else {
            return false
        }
    }
}
