import CFomaSystem

struct Foma {
    let version = String(cString: fsm_get_library_version_string())
}

