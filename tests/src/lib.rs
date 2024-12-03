use std::ffi::c_void;

mod ft_strcpy;
mod ft_strdup;
mod ft_strlen;
mod ft_strcmp;
#[cfg(test)]
pub mod test;

#[link(name = "c", kind = "dylib")]
extern "C" {
    #[allow(dead_code)]
    fn free(ptr: *mut c_void);
}
