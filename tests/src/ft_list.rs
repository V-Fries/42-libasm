mod ft_list_push_front;

use std::ffi::c_void;


#[repr(C)]
pub struct FtList {
    data: *mut c_void,
    next: *mut FtList,
}
