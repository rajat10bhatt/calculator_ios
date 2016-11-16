//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Rajat Bhatt on 16/11/16.
//  Copyright © 2016 RAJATsadasfdsfds. All rights reserved.
//

import Foundation

//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}

class CalculatorBrain{
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    /* Using closures:-
     Step 1: Take function without its name
     (op1: Double, op2: Double) -> Double {
     return op1 * op2
     }
     
     Step 2: take open curly bracket to start of the closure and put "in" in place of curly bracket
     {(op1: Double, op2: Double) -> Double in
     return op1 * op2
     }
     
     Step 3: The above is a closure but swift can infer that the Binart function takes two doubles and return a double so we can write
     {(op1, op2) in return op1 * op2}
     
     Step 4: Closures have their default arguments names as $0, $1, $2... so we can write
     {($0, $1) in return $0 * $1}
     {return $0 * $1}
     
     Step 5: If we use default arguments names of a closure, we can write
     {$0 * $1}
     */
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({-$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
   private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func peformOperation(symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperations()
                pending = pendingOperation(pendingOperation: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperations()
            }
        }
    }
    
    func executePendingBinaryOperations() {
        if pending != nil {
            accumulator = pending!.pendingOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingOperation?
    
    private struct pendingOperation {
        var pendingOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}