//
//  ViewController.swift
//  GroupByFirstLetter
//
//  Created by 高永效 on 15/12/8.
//  Copyright © 2015年 EgeTart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var citysTableView: UITableView!

    let citys = ["北京市", "上海市", "天津市", "重庆市", "合肥市", "毫州市", "芜湖市", "马鞍山市", "池州市", "黄山市", "滁州市", "安庆市", "淮南市", "淮北市", "蚌埠市", "巢湖市", "宿州市", "六安市", "阜阳市", "铜陵市", "明光市", "天长市", "宁国市", "界首市", "桐城市", "广州市", "韶关市", "深圳市", "珠海市", "汕头市", "佛山市", "江门市", "湛江市", "茂名市", "肇庆市", "惠州市", "梅州市", "汕尾市", "河源市", "阳江市", "清远市", "东莞市", "中山市", "潮州市", "揭阳市", "云浮市", "昆明市", "曲靖市", "玉溪市", "保山市", "昭通市", "丽江市", "思茅市", "临沧市", "楚雄彝族自治州", "红河哈尼族彝族自治州", "文山壮族苗族自治州", "西双版纳傣族自治州", "大理白族自治州", "德宏傣族景颇族自治州", "怒江傈僳族自治州", "迪庆藏族自治州"]
    
    var cityGroups = [String: [String]]()
    var groupTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citysTableView.dataSource = self
        citysTableView.delegate = self
        
        makeCityToGroup()
    }
    
    func makeCityToGroup() {
        // 遍历citys数组中的所有城市
        for city in citys {
            
            // 将中文转换为拼音
            let cityMutableString = NSMutableString(string: city)
            CFStringTransform(cityMutableString, nil, kCFStringTransformToLatin, false)
            CFStringTransform(cityMutableString, nil, kCFStringTransformStripDiacritics, false)
            
            // 拿到首字母作为key
            let firstLetter = cityMutableString.substringToIndex(1).uppercaseString
            
            // 检查是否有firstLetter对应的分组存在, 有的话直接把city添加到对应的分组中
            // 没有的话, 新建一个以firstLetter为key的分组
            if var value = cityGroups[firstLetter] {
                value.append(city)
                cityGroups[firstLetter] = value
            }
            else {
                cityGroups[firstLetter] = [city]
            }
        }
        
        //拿到所有的key将它排序, 作为每个组的标题
        groupTitles = cityGroups.keys.sort()
    }

}

extension ViewController: UITableViewDataSource {
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return groupTitles
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cityGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstLetter = groupTitles[section]
        return cityGroups[firstLetter]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let firstLetter = groupTitles[indexPath.section]
        let citysInAGroup = cityGroups[firstLetter]!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = citysInAGroup[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTitles[section]
    }
}


