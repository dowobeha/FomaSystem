import CFomaSystem

public struct Foma {
    public static let version = String(cString: fsm_get_library_version_string())

    public typealias ReadHandleToIntFunction = (UnsafeMutablePointer<fsm_read_handle>?) -> Int32
    
    public typealias UnaryApplyFunction = (UnsafeMutablePointer<apply_handle>?) -> UnsafeMutablePointer<CChar>?
    public typealias BinaryApplyFunction = (UnsafeMutablePointer<apply_handle>?, UnsafeMutablePointer<CChar>?) -> UnsafeMutablePointer<CChar>?
}
