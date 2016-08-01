//
//  ViewController.swift
//  Calculator
//
//  Created by Bell, Courtney on 7/12/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var brain = CalculatorBrain()
    
    private var userInTheMiddleOfTyping = false
    
    //Courtney Bell
    //string variable to store description of how 'result' was achieved
    private var descriptionString = ""
    
    //Courtney Bell
    //bool variable to tell if binary result is pending or not
    private var isPartialResult = false
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator (count = \(calculatorCount))")
        brain.addUnaryOperation(symbol: "Z") { [ unowned me = self] in
            me.display.textColor = UIColor.red()
            return sqrt($0)
        }
        
    }
 
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping{
            //Courtney Bell
            //if . already exists in current string ignore it (not a legal float) - otherwise append to string
            if(digit == ".") && (display.text!.range(of: ".") != nil){
                return
            }else{
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            }

        }else{
            //Courtney Bell
            //if . is first 'digit' pressed display should show 0.
            if digit == "."{
                display.text = "0."
            }else{
                display.text = digit
            }
        }
        
        userInTheMiddleOfTyping = true
        
        //Courtney Bell
        //appends proper ending to description string
        buildDescriptionString(digit: digit)
        
    }

    private func buildDescriptionString(digit: String){

        //Courtney Bell
        //sets isPartialResult depending on whether or not
        //there is a pending binary
        if(brain.pending != nil){
            isPartialResult = true
        }else{
            isPartialResult = false
        }
        
        //Courtney Bell
        //adds digit to description string unless it is an =
        if(digit == "="){
            isPartialResult = false
            checkIfPartial()
            return
        }else{
            descriptionString += digit
        }
        
        checkIfPartial()
    }
    
    //Courtney Bell
    //appends proper ending to description string
    private func checkIfPartial(){
        if(isPartialResult){
            descriptionLabel.text = descriptionString + "..."
        }else if(!isPartialResult && userInTheMiddleOfTyping){
            descriptionLabel.text = descriptionString
        }else if(!isPartialResult && !userInTheMiddleOfTyping){
            descriptionLabel.text = descriptionString + "="
        }else{
            return
        }
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    //Courtney Bell
    //resets display to 0, clears description label
    @IBAction func clear(_ sender: UIButton) {
        if display.text != nil{
            display.text = "0"
            descriptionString = " "
            descriptionLabel.text = descriptionString
            userInTheMiddleOfTyping = false
        }
    }

    @IBAction private func performOperation(_ sender: UIButton) {
        
        let title = sender.currentTitle
        
        if userInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            isPartialResult = true
            userInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = title{
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        buildDescriptionString(digit: title!)
        displayValue = brain.result
        
    }
}

