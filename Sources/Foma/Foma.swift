import CFomaSystem

extension String {
    
    func unsafeMutablePointer() -> UnsafeMutablePointer<CChar> {
        let cString: UnsafeMutablePointer<CChar> = self.withCString { (cString:UnsafePointer<CChar>) in
            return UnsafeMutablePointer<CChar>(mutating: cString)
        }
        return cString
    }
    
}

struct Foma {
    static let version = String(cString: fsm_get_library_version_string())
}

class FSM {
    private var fsmPointer : UnsafeMutablePointer<fsm>
    private var applyHandle: UnsafeMutablePointer<apply_handle>
    
    init(fromBinary binaryFilename: String) {
        self.fsmPointer = fsm_read_binary_file(binaryFilename.unsafeMutablePointer())
        self.applyHandle = apply_init(fsmPointer)
    }
    
    private init(fromPointer unsafeMutablePointer: UnsafeMutablePointer<fsm>) {
        self.fsmPointer = unsafeMutablePointer
        self.applyHandle = apply_init(fsmPointer)
    }
    
    deinit {
        apply_clear(self.applyHandle)
        fsm_destroy(self.fsmPointer)
    }
    
    func applyUp(_ s: String) -> String {
        let result: UnsafeMutablePointer<CChar> = apply_up(self.applyHandle, s.unsafeMutablePointer())
        return String(cString: result)
    }

    func applyDown(_ s: String) -> String {
        let result: UnsafeMutablePointer<CChar> = apply_down(self.applyHandle, s.unsafeMutablePointer())
        return String(cString: result)
    }
    
    func randomLower() -> String {
        let result: UnsafeMutablePointer<CChar> = apply_random_lower(self.applyHandle)
        return String(cString: result)
    }

    func randomUpper() -> String {
        let result: UnsafeMutablePointer<CChar> = apply_random_upper(self.applyHandle)
        return String(cString: result)
    }
    
    func numStates() -> Int {
        let readHandle: UnsafeMutablePointer<fsm_read_handle> = fsm_read_init(self.fsmPointer)
        defer {
            fsm_read_done(readHandle)
        }
        return Int(fsm_get_num_states(readHandle))
    }
    
    func union(_ other: FSM) -> FSM {
        return FSM(fromPointer: fsm_union(self.fsmPointer, other.fsmPointer))
    }
    
}
