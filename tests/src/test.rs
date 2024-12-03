use std::ffi::{c_char, CStr};

#[link(name = "c", kind = "dylib")]
extern "C" {
    #[allow(dead_code)]
    pub fn strcmp(str1: *const c_char, str2: *const c_char) -> i32;

    #[allow(dead_code)]
    pub fn __errno_location() -> *mut i32;
}

#[allow(clippy::missing_safety_doc)]
pub unsafe fn assert_cstr_eq(str1: *const c_char, str2: *const c_char) {
    let mut str1_cursor = str1;
    let mut str2_cursor = str2;

    while *str1_cursor != '\0' as c_char && *str2_cursor != b'\0' as c_char {
        str1_cursor = str1_cursor.offset(1);
        str2_cursor = str2_cursor.offset(1);
    }
    if *str1_cursor != '\0' as c_char || *str2_cursor != b'\0' as c_char {
        panic!(
            "Asserton failed: {:?} != {:?}",
            CStr::from_ptr(str1),
            CStr::from_ptr(str2)
        );
    }
}
