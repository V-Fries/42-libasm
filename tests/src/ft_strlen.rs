use std::ffi::c_char;

#[link(name = "asm", kind = "static")]
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
    }
}
