//
//  SystemStatsViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/08/2025.
//

import SwiftUI
import Combine

final class SystemStatsViewModel: ObservableObject {
    @Published var usedMemoryMB: Double = 0
    @Published var threadCount: Int = 0
    @Published var cpuUsage: Double = 0
    
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 2.0,
            repeats: true
        ) { _ in
            self.usedMemoryMB = self.reportMemoryUsage()
            self.threadCount = self.reportThreadCount()
            self.cpuUsage = self.reportCPUUsage()
        }
    }
    
    private func reportMemoryUsage() -> Double {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) /
                                           MemoryLayout<Int32>.size)
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(
                    mach_task_self_,
                    task_flavor_t(TASK_VM_INFO),
                    $0,
                    &count
                )
            }
        }
        
        guard result == KERN_SUCCESS else { return -1 }
        return Double(info.phys_footprint) / 1048576.0
    }
    
    private func reportThreadCount() -> Int {
        var count: mach_msg_type_number_t = 0
        var threadList: thread_act_array_t?
        
        let kr = task_threads(mach_task_self_, &threadList, &count)
        guard kr == KERN_SUCCESS else { return -1 }
        
        return Int(count)
    }
    
    private func reportCPUUsage() -> Double {
        var threads: thread_act_array_t?
        var threadCount = mach_msg_type_number_t()
        
        let kr = task_threads(mach_task_self_, &threads, &threadCount)
        guard kr == KERN_SUCCESS else { return -1 }
        
        var totalCPU: Double = 0
        
        if let threads {
            for i in 0..<Int(threadCount) {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                
                let result = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(
                        to: integer_t.self,
                        capacity: Int(threadInfoCount)
                    ) {
                        thread_info(
                            threads[i],
                            thread_flavor_t(THREAD_BASIC_INFO),
                            $0,
                            &threadInfoCount
                        )
                    }
                }
                
                guard result == KERN_SUCCESS else { continue }
                
                if threadInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalCPU += Double(threadInfo.cpu_usage) /
                    Double(TH_USAGE_SCALE) * 100.0
                }
            }
        }
        
        return totalCPU
    }
    
    deinit {
        timer?.invalidate()
    }
}

#Preview {
    PreviewContentView.contentView
}
