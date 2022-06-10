//
//  TaskQueue.swift
//  SwiftlyRT
//

import Foundation

// Source: https://stackoverflow.com/questions/71586634/swift-5-6-how-to-put-async-task-into-a-queue
// Author: https://stackoverflow.com/users/10317684/ricky-mo

class TaskQueue{

    private actor TaskQueueActor{
        private var blocks : [() async -> Void] = []
        private var currentTask : Task<Void,Never>? = nil

        func addBlock(block:@escaping () async -> Void){
            blocks.append(block)
            next()
        }

        func next()
        {
            if(currentTask != nil) {
                return
            }
            if(!blocks.isEmpty)
            {
                let block = blocks.removeFirst()
                currentTask = Task{
                    await block()
                    currentTask = nil
                    next()
                }
            }
        }
    }
    private let taskQueueActor = TaskQueueActor()

    func dispatch(block:@escaping () async ->Void){
        Task{
            await taskQueueActor.addBlock(block: block)
        }
    }
}
