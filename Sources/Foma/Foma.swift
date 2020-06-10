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
}

public class FST {
    private var fsmPointer : UnsafeMutablePointer<fsm>
    private var applyHandle: UnsafeMutablePointer<apply_handle>
    
    public init?(fromBinary binaryFilename: String) {

        if let pointer = fsm_read_binary_file(binaryFilename.unsafeMutablePointer()) {
            self.fsmPointer = pointer
        } else {
            return nil
        }

        if let handle = apply_init(fsmPointer) {
            self.applyHandle = handle
        } else {
            return nil
        }
    }
    
    private init(fromPointer unsafeMutablePointer: UnsafeMutablePointer<fsm>) {
        self.fsmPointer = unsafeMutablePointer
        self.applyHandle = apply_init(fsmPointer)
    }
    
    deinit {
        apply_clear(self.applyHandle)
        fsm_destroy(self.fsmPointer)
    }
    
    public func applyUp(_ s: String) -> String {
        let result: UnsafeMutablePointer<CChar> = apply_up(self.applyHandle, s.unsafeMutablePointer())
        return String(cString: result)
    }

    public func applyDown(_ s: String) -> String {
        let result: UnsafeMutablePointer<CChar> = apply_down(self.applyHandle, s.unsafeMutablePointer())
        return String(cString: result)
    }
    
    public func randomLower() -> String {
        let result: UnsafeMutablePointer<CChar> = apply_random_lower(self.applyHandle)
        return String(cString: result)
    }

    public func randomUpper() -> String {
        let result: UnsafeMutablePointer<CChar> = apply_random_upper(self.applyHandle)
        return String(cString: result)
    }
    
    public func numStates() -> Int {
        let readHandle: UnsafeMutablePointer<fsm_read_handle> = fsm_read_init(self.fsmPointer)
        defer {
            fsm_read_done(readHandle)
        }
        return Int(fsm_get_num_states(readHandle))
    }
    
    public func union(_ other: FST) -> FST {
        return FST(fromPointer: fsm_union(self.fsmPointer, other.fsmPointer))
    }
    
}
