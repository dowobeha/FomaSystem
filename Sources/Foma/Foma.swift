import CFomaSystem

extension String {
    
    func unsafeMutablePointer() -> UnsafeMutablePointer<CChar> {
        let cString: UnsafeMutablePointer<CChar> = self.withCString { (cString:UnsafePointer<CChar>) in
            return UnsafeMutablePointer<CChar>(mutating: cString)
        }
        return cString
    }
    
}

public struct Foma {
    public static let version = String(cString: fsm_get_library_version_string())

    public typealias ReadHandleToIntFunction = (UnsafeMutablePointer<fsm_read_handle>?) -> Int32
    
    public typealias UnaryApplyFunction = (UnsafeMutablePointer<apply_handle>?) -> UnsafeMutablePointer<CChar>?
    public typealias BinaryApplyFunction = (UnsafeMutablePointer<apply_handle>?, UnsafeMutablePointer<CChar>?) -> UnsafeMutablePointer<CChar>?
}

public class FST {
    private var fsmPointer : UnsafeMutablePointer<fsm>
    //private var applyHandle: UnsafeMutablePointer<apply_handle>
    
    public init?(fromBinary binaryFilename: String) {

        if let pointer = fsm_read_binary_file(binaryFilename.unsafeMutablePointer()) {
            self.fsmPointer = pointer
        } else {
            return nil
        }
/*
        if let handle = apply_init(fsmPointer) {
            self.applyHandle = handle
        } else {
            return nil
        }
 */
    }
    
    private init(fromPointer unsafeMutablePointer: UnsafeMutablePointer<fsm>) {
        self.fsmPointer = unsafeMutablePointer
        //self.applyHandle = apply_init(fsmPointer)
    }
    
    deinit {
        //apply_clear(self.applyHandle)
        fsm_destroy(self.fsmPointer)
    }
    
    private func apply(function applyFunction: Foma.BinaryApplyFunction, to string:String) -> [String] {
        var results = [String]()
        
        if let applyHandle = apply_init(fsmPointer) {
            defer {
                apply_clear(applyHandle)
            }
            if let result: UnsafeMutablePointer<CChar> = applyFunction(applyHandle, string.unsafeMutablePointer()) {
                results.append(String(cString: result))
            }
        }

        return results
    }
    
    private func apply(function applyFunction: Foma.UnaryApplyFunction) -> String? {
        
        if let applyHandle = apply_init(fsmPointer) {
            defer {
                apply_clear(applyHandle)
            }
            if let result = applyFunction(applyHandle) {
                return String(cString: result)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    private func read(function readFunction: Foma.ReadHandleToIntFunction) -> Int {
        let readHandle: UnsafeMutablePointer<fsm_read_handle> = fsm_read_init(self.fsmPointer)
        defer {
            fsm_read_done(readHandle)
        }
        return Int(readFunction(readHandle))
    }
    
    public func applyUp(_ s: String) -> [String] {
        return self.apply(function: apply_up, to: s)
    }
    
    public func applyDown(_ s: String) -> [String] {
        return self.apply(function: apply_down, to: s)
    }
    
    public func randomLower() -> String? {
        return self.apply(function: apply_random_lower)
    }

    public func randomUpper() -> String? {
        return self.apply(function: apply_random_upper)
    }
    
    public func numStates() -> Int {
        return self.read(function: fsm_get_num_states)
    }
    
    public func union(_ other: FST) -> FST {
        return FST(fromPointer: fsm_union(self.fsmPointer, other.fsmPointer))
    }
    
}
