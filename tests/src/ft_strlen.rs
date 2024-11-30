use std::ffi::c_char;

#[link(name = "asm")]
extern "C" {
    #[allow(dead_code)]
    fn ft_strlen(str: *const c_char) -> usize;
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn strlen() {
        assert_eq!(unsafe { ft_strlen(c"test".as_ptr()) }, 4);
        assert_eq!(unsafe { ft_strlen(c"".as_ptr()) }, 0);

        const SIZE: usize = i32::MAX as usize + 10;
        let mut str = (0..SIZE).map(|_| b'a' as c_char).collect::<Vec<_>>();
        str[SIZE - 1] = b'\0' as c_char;
        assert_eq!(unsafe { ft_strlen(str.as_ptr()) }, SIZE - 1);
    }
}
