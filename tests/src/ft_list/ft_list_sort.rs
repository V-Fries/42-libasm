use std::ffi::c_void;

use super::FtList;

#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_list_sort(
        head: *mut *mut FtList,
        cmp: unsafe extern "C" fn(*mut c_void, *mut c_void) -> i32,
    );
}

#[cfg(test)]
mod test {
    use super::*;

    use std::{ffi::c_void, ptr};

    use crate::ft_list::{ft_list_push_front::ft_list_push_front, list_destroy, FtList};

    extern "C" fn cmp(n1: *mut c_void, n2: *mut c_void) -> i32 {
        (n1 as isize - n2 as isize) as i32
    }

    #[test]
    fn list_sort() {
        let mut list: *mut FtList = ptr::null_mut();

        for i in 0..42 {
            unsafe { ft_list_push_front(&mut list, i as *mut c_void) }
        }
        let mut cursor = list;
        for i in (0..42).rev() {
            assert!(!cursor.is_null());
            assert_eq!(unsafe { (*cursor).data }, i as *mut c_void);
            cursor = unsafe { (*cursor).next };
        }
        unsafe { ft_list_sort(&mut list, cmp) }
        let mut cursor = list;
        for i in 0..42 {
            assert!(!cursor.is_null());
            assert_eq!(unsafe { (*cursor).data }, i as *mut c_void);
            cursor = unsafe { (*cursor).next };
        }

        for i in (42..6356).rev() {
            unsafe { ft_list_push_front(&mut list, (i * 546) as *mut c_void) }
            unsafe { ft_list_push_front(&mut list, i as *mut c_void) }
            unsafe { ft_list_push_front(&mut list, -i as *mut c_void) }
            unsafe { ft_list_push_front(&mut list, -i as *mut c_void) }
            unsafe { ft_list_push_front(&mut list, (-i * 657) as *mut c_void) }
        }
        unsafe { ft_list_sort(&mut list, cmp) }
        let mut cursor = list;
        let mut previous = isize::MIN;
        let mut i = 0;
        while !cursor.is_null() {
            assert!(unsafe { (*cursor).data } as isize >= previous, "loop nb {i}");
            previous = unsafe { (*cursor).data } as isize;
            cursor = unsafe { (*cursor).next };
            i += 1;
        }

        unsafe { list_destroy(&mut list) }
    }
}
