use std::ffi::c_char;

#[link(name = "asm")]
extern "C" {
    #[allow(dead_code)]
    fn ft_strcpy(dest: *mut c_char, src: *const c_char) -> *mut c_char;
}

#[cfg(test)]
mod test {
    use std::ffi::{c_char, CStr};

    macro_rules! assert_strcpy {
        ($dst:expr, $src:expr) => {
            let dst = $dst.to_owned().into_raw();
            let src = $src;

            assert_eq!(unsafe { super::ft_strcpy(dst, src.as_ptr()) }, dst);

            let dst = unsafe { std::ffi::CString::from_raw(dst) };
            assert_eq!(dst, src.to_owned());
        };
    }

    macro_rules! assert_strcpy_literals {
        ($dst:literal, $src:literal) => {
            assert_strcpy!($dst.to_owned(), $src.to_owned());
        };
    }

    #[test]
    fn strcpy() {
        assert_strcpy_literals!(c"hello", c"test");

        assert_strcpy_literals!(c"test", c"test");

        assert_strcpy_literals!(c"test", c"");

        const SIZE: usize = i32::MAX as usize + 10;
        let mut dst = (0..SIZE).map(|_| b'a' as c_char).collect::<Vec<_>>();
        dst[SIZE - 5] = b'\0' as c_char;
        let mut src = (0..SIZE).map(|_| b'b' as c_char).collect::<Vec<_>>();
        src[SIZE - 3] = b'\0' as c_char;
        assert_strcpy!(
            unsafe { CStr::from_ptr(dst.as_ptr()) },
            unsafe { CStr::from_ptr(src.as_ptr()) }
        );
    }
}
