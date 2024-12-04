mod ft_list_push_front;
mod ft_list_remove_if;
mod ft_list_size;

use std::ffi::c_void;

#[repr(C)]
pub struct FtList {
    data: *mut c_void,
    next: *mut FtList,
}

#[allow(dead_code)]
pub unsafe fn list_destroy(list: *mut *mut FtList) {
    assert!(!list.is_null());

    while !(*list).is_null() {
        let next = (**list).next;
        crate::libc::free((*list).cast());
        *list = next;
    }
}
