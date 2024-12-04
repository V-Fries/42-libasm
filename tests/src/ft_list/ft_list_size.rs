use super::FtList;

#[link(name = "c", kind = "dylib")]
#[link(name = "asm", kind = "static")]
extern "C" {
    #[allow(dead_code)]
    fn ft_list_size(head: *const FtList) -> i32;
}

#[cfg(test)]
mod test {
    use std::ptr;

    use super::*;

    #[test]
    fn list_size() {
        assert_eq!(unsafe { ft_list_size(ptr::null()) }, 0);

        let mut list = FtList {
            data: ptr::null_mut(),
            next: ptr::null_mut(),
        };

        assert_eq!(unsafe { ft_list_size(&list) }, 1);

        let list2 = FtList {
            data: ptr::null_mut(),
            next: &mut list,
        };

        assert_eq!(unsafe { ft_list_size(&list2) }, 2);
    }
}
