use std::ffi::c_void;

use super::FtList;

#[link(name = "c", kind = "dylib")]
#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_list_push_front(head: *mut *mut FtList, data: *mut c_void);
}

#[cfg(test)]
mod test {
    use std::ptr;

    use super::*;

    #[test]
    fn list_push_front() {
        let mut head: *mut FtList = ptr::null_mut();

        let val1 = 42 as *mut c_void;
        unsafe { ft_list_push_front(&mut head, val1) };
        assert_ne!(head, ptr::null_mut());
        assert_eq!(unsafe { (*head).data }, val1);

        let val2 = 65 as *mut c_void;
        unsafe { ft_list_push_front(&mut head, val2) };
        assert_eq!(unsafe { (*head).data }, val2);
        assert_eq!(unsafe { (*(*head).next).data }, val1);

        unsafe { crate::libc::free((*head).next.cast()) };
        unsafe { crate::libc::free(head.cast()) };
    }
}
