use std::ffi::c_void;

#[link(name = "c", kind = "dylib")]
extern "C" {
    #[allow(dead_code)]
    pub fn free(ptr: *mut c_void);
}
