//
//  FiltersViewControllerDelegate.swift
//  Tracker
//
//  Created by Андрей Пермяков on 09.01.2026.
//
protocol FiltersViewControllerDelegate: AnyObject {
    func filtersViewController(_ controller: FiltersViewController, didSelectFilter filter: FilterList)
}
