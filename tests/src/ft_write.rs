use std::ffi::c_void;

#[link(name = "c", kind = "dylib")]
#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_write(fd: i32, buf: *const c_void, count: usize) -> isize;
}

#[cfg(test)]
mod test {
    use crate::test::assert_cstr_eq;

    use super::*;
    use std::{
        ffi::CStr, fs::{remove_file, File}, io::Read, os::fd::AsRawFd, ptr::null_mut
    };

    const TEST_FILE: &str = "ft_write_test.txt";

    #[test]
    fn write() {
        let file = File::create(TEST_FILE).unwrap();

        const STR1: &CStr = c"Super cool\n";
        const STR1_LEN: usize = STR1.count_bytes();
        assert_eq!(unsafe { ft_write(file.as_raw_fd(), STR1.as_ptr().cast(), STR1_LEN) }, STR1_LEN as isize);
        const STR2: &CStr = c"Wow";
        const STR2_LEN: usize = STR2.count_bytes();
        assert_eq!(unsafe { ft_write(file.as_raw_fd(), STR2.as_ptr().cast(), STR2_LEN) }, STR2_LEN as isize);

        drop(file);


        let mut file = File::open(TEST_FILE).unwrap();

        let mut buf = [0u8; STR1_LEN + 1];
        file.read_exact(&mut buf[..STR1_LEN]).unwrap();
        buf[STR1_LEN] = b'\0';
        unsafe { assert_cstr_eq(STR1.as_ptr(), buf.as_ptr().cast()) };

        let mut buf2 = [0u8; STR2_LEN + 1];
        file.read_exact(&mut buf2[..STR2_LEN]).unwrap();
        buf2[STR2_LEN] = b'\0';
        unsafe { assert_cstr_eq(STR2.as_ptr(), buf2.as_ptr().cast()) };

        let mut vec = Vec::new();
        file.read_to_end(&mut vec).unwrap();
        assert!(vec.is_empty());

        remove_file(TEST_FILE).unwrap();
    }

    #[test]
    fn write_errno_change() {
        assert_eq!(unsafe { ft_write(-1, null_mut(), 0) }, -1);
        assert_eq!(unsafe { *crate::test::__errno_location() }, 9);
    }
}
