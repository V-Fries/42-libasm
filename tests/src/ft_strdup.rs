use std::ffi::c_char;

#[link(name = "c", kind = "dylib")]
#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_strdup(str: *const c_char) -> *mut c_char;
}

#[cfg(test)]
mod test {
    use super::*;

    macro_rules! assert_strdup {
        ($str:expr) => {
            let str = $str.to_owned();

            let dup = unsafe { ft_strdup(str.as_ptr()) };
            assert_ne!(dup, std::ptr::null_mut());
            let expected = unsafe { std::ffi::CStr::from_ptr(dup).to_owned() };

            unsafe { crate::free(dup.cast()) }

            assert_eq!(str, expected);
        };
    }

    #[test]
    fn strdup() {
        assert_strdup!(c"test");

        assert_strdup!(c"");
    }
}
