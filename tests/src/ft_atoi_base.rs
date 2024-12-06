use std::ffi::c_char;

#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_atoi_base(str: *const c_char, base: *const c_char) -> i32;
}

#[cfg(test)]
mod test {
    use super::*;

    const BASE_10: *const c_char = c"0123456789".as_ptr();
    const HEXA: *const c_char = c"0123456789abcdef".as_ptr();

    #[test]
    fn atoi_base() {
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), BASE_10) }, 42);
        assert_eq!(unsafe { ft_atoi_base(c"0009420000".as_ptr(), BASE_10) }, 9420000);
        assert_eq!(unsafe { ft_atoi_base(c"             ++++----+++----+++42hrgr".as_ptr(), BASE_10) }, 42);
        assert_eq!(unsafe { ft_atoi_base(c"-++++----+++----+++42hrgr".as_ptr(), BASE_10) }, -42);

        assert_eq!(unsafe { ft_atoi_base(c"2a".as_ptr(), HEXA) }, 42);
        assert_eq!(unsafe { ft_atoi_base(c"0008fbce0".as_ptr(), HEXA) }, 9420000);
        assert_eq!(unsafe { ft_atoi_base(c"             ++++----+++----+++2ahrgr".as_ptr(), HEXA) }, 42);
        assert_eq!(unsafe { ft_atoi_base(c"-++++----+++----+++2ahrgr".as_ptr(), HEXA) }, -42);

        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"".as_ptr()) }, 0);
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"4".as_ptr()) }, 0);
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"0123456789+".as_ptr()) }, 0);
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"0123456789-".as_ptr()) }, 0);
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"0123456789 ".as_ptr()) }, 0);
        assert_eq!(unsafe { ft_atoi_base(c"42".as_ptr(), c"00123456789".as_ptr()) }, 0);
    }
}
