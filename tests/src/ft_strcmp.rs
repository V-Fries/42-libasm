use std::ffi::c_char;

#[link(name = "asm_bonus", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_strcmp(str: *const c_char, str2: *const c_char) -> i32;
}

#[cfg(test)]
mod test {
    use super::*;

    macro_rules! assert_strcmp {
        ($str1:expr, $str2:expr) => {
            let got = unsafe { ft_strcmp($str1.as_ptr(), $str2.as_ptr()) };
            let expected = unsafe { crate::test::strcmp($str1.as_ptr(), $str2.as_ptr()) };
            assert_eq!(got.signum(), expected.signum());
        };
    }

    #[test]
    fn strcmp() {
        assert_strcmp!(c"", c"");
        assert_strcmp!(c"42", c"40");
        assert_strcmp!(c"42", c"44");
        assert_strcmp!(c"42", c"42");
    }
}
