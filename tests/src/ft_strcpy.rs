use std::ffi::c_char;

#[link(name = "asm_bonus", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_strcpy(dest: *mut c_char, src: *const c_char) -> *mut c_char;
}

#[cfg(test)]
mod test {
    macro_rules! assert_strcpy {
        ($dst:expr, $src:expr) => {
            let dst = $dst.to_owned();
            let src = $src;

            assert_eq!(
                unsafe { super::ft_strcpy(dst.as_ptr().cast_mut(), src.as_ptr()) },
                dst.as_ptr().cast_mut()
            );

            unsafe { crate::test::assert_cstr_eq(dst.as_ptr(), src.as_ptr()) }
        };
    }

    #[test]
    fn strcpy() {
        assert_strcpy!(c"hello", c"test");

        assert_strcpy!(c"test", c"test");

        assert_strcpy!(c"test", c"");
    }
}
