//
//  OnboardingViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit

class Slide1ViewController: UIViewController,PageViewDelegate {
    func updatePageViewController() {
        print("zzzzzzzzzzzzzz")
    }
    

    
    @IBOutlet weak var tvDesription: UITextView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let  vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "onbord") as? OnboardingViewControllerMain{
             vc.nDelegate = self
         }
      uiSetup()
    }
    private func uiSetup(){
        tvDesription.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
        tvDesription.text = "Oснивач је Мисије, сада Задужбине Манастира Хиландара у Београду, којом је руководио три године. Такође је оснивач Издавачке куће „Принцип Прес“ и престижног магазина Србија – Национална ревија.\n \nПриређивач је капиталних монографија на више светских језика: Туристичка библија Србије, Србија – од злата јабука, Бој изнад векова – стогодишњица Кумановске битке, Србија – друмовима, пругама, рекама и др.\n \n Руководилац је више пројеката из области културе, међу којима су значајнији „Србија на међународним сајмовима књига – Лајпциг, Пекинг, Москва, Франкфурт 2019“ као и подухват дигитализације културног наслеђа и савременог стваралаштва „Србија национална ревија — пут у дигитализовани свет културне баштине Србије“"
    }
}
