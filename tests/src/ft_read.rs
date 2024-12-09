use std::ffi::c_void;

#[link(name = "c", kind = "dylib")]
#[link(name = "asm_bonus", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_read(fd: i32, buf: *mut c_void, count: usize) -> isize;
}

#[cfg(test)]
mod test {
    use super::*;
    use std::{
        fs::{remove_file, File},
        io::Write,
        os::fd::AsRawFd,
        ptr::null_mut,
    };

    const TEST_FILE: &str = "ft_read_test.txt";

    #[test]
    fn read() {
        let mut file = File::create(TEST_FILE).unwrap();
        let str1 = c"Super cool\n";
        let str1_len = str1.count_bytes();
        file.write_all(str1.to_bytes()).unwrap();
        let str2 = c"Wow";
        let str2_len = str2.count_bytes();
        file.write_all(str2.to_bytes()).unwrap();

        let file = File::open(TEST_FILE).unwrap();

        let mut buf = [0i8; 100];

        assert_eq!(
            unsafe { ft_read(file.as_raw_fd(), buf.as_mut_ptr().cast(), str1_len) },
            str1_len as isize
        );
        unsafe { crate::test::assert_cstr_eq(str1.as_ptr(), buf.as_ptr()) };
        assert_eq!(
            unsafe { ft_read(file.as_raw_fd(), buf.as_mut_ptr().cast(), str2_len) },
            str2_len as isize
        );
        buf[str2_len] = 0;
        unsafe { crate::test::assert_cstr_eq(str2.as_ptr(), buf.as_ptr()) };

        remove_file(TEST_FILE).unwrap();
    }

    #[test]
    fn read_errno_change() {
        assert_eq!(unsafe { ft_read(-1, null_mut(), 0) }, -1);
        assert_eq!(unsafe { *crate::test::__errno_location() }, 9);
    }
}
