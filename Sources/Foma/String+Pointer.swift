
// Provides an extension to the Swift String class
//   to allow the user to get a C-style string
//   for use in interacting with C libraries.
extension String {
    
    // Returns a C-style pointer to this string
    func unsafeMutablePointer() -> UnsafeMutablePointer<CChar> {
        let cString: UnsafeMutablePointer<CChar> = self.withCString { (cString:UnsafePointer<CChar>) in
            return UnsafeMutablePointer<CChar>(mutating: cString)
        }
        return cString
    }
    
}
