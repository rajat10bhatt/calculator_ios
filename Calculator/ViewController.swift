//
//  ViewController.swift
//  Calculator
//
//  Created by Rajat Bhatt on 15/11/16.
//  Copyright © 2016 RAJATsadasfdsfds. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new calculator (count = \(calculatorCount))")
        //if we do it with self.display it will be held in memory and deinit will never be called as controller will never leave the heap. So to make view controller leave the heap on click of back button we rename self as unowned or weak so that there is no deadlock and controller can leave the heap
        
        /*The function calling below can also be written as:-
         
         brain.addUnaryOperation("√" , operation: { (x: double) -> double in
         me.display.textColor = UIColor.redColor()
         return sqrt(x)
         }
         
         which is furthur reduced to:-
         
         brain.addUnaryOperation("√") { (x: double) -> double in
         me.display.textColor = UIColor.redColor()
         return sqrt(x)
         }
         
         as closure is the last argument so it can be written as it is written above 
         After this we get the final function call as below
         */
        
        brain.addUnaryOperation("√") { [unowned me = self] in
            me.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit{
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double{
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    let brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
           brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

