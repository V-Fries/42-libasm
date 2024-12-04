use std::ffi::c_void;

use super::FtList;

extern "C" {
    #[allow(dead_code)]
    fn ft_list_remove_if(
        head: *mut *mut FtList,
        data_ref: *mut c_void,
        cmp: unsafe extern "C" fn(*mut c_void, *mut c_void) -> i32,
        free_fct: unsafe extern "C" fn(*mut c_void),
    );
}

#[cfg(test)]
mod test {
    use std::{ptr, sync::Mutex};

    use crate::ft_list::{ft_list_push_front::ft_list_push_front, list_destroy};

    use super::*;

    static ASSERT_TEST_VALUE_CALL_COUNT: Mutex<usize> = Mutex::new(0);
    static DO_NOTHING_CALL_COUNT: Mutex<usize> = Mutex::new(0);
    const LIST_LEN: usize = 43;
    const TEST_VALUE: *mut c_void = 42 as *mut c_void;

    extern "C" fn return_pos(_: *mut c_void, _: *mut c_void) -> i32 {
        1
    }
    extern "C" fn return_0(_: *mut c_void, _: *mut c_void) -> i32 {
        0
    }
    extern "C" fn return_neg(_: *mut c_void, _: *mut c_void) -> i32 {
        -1
    }

    extern "C" fn do_nothing(_: *mut c_void) {
        *DO_NOTHING_CALL_COUNT.lock().unwrap() += 1;
    }

    extern "C" fn panic(_: *mut c_void) {
        panic!("panic() was called");
    }

    extern "C" fn assert_test_value(data: *mut c_void) {
        *ASSERT_TEST_VALUE_CALL_COUNT.lock().unwrap() += 1;
        assert_eq!(data, TEST_VALUE);
    }

    extern "C" fn return_0_if_test_value(data: *mut c_void, test_value: *mut c_void) -> i32 {
        assert_eq!(test_value, 42 as *mut c_void);
        if data == test_value {
            return 0;
        }
        1
    }

    #[test]
    fn list_remove_if() {
        let mut list: *mut FtList = ptr::null_mut();

        for i in 0..LIST_LEN {
            unsafe { ft_list_push_front(&mut list, i as *mut c_void) }
        }

        unsafe { ft_list_remove_if(&mut list, ptr::null_mut(), return_pos, panic) }
        unsafe { ft_list_remove_if(&mut list, ptr::null_mut(), return_neg, panic) }
        let mut cursor = list;
        for i in (0..LIST_LEN).rev() {
            assert!(!cursor.is_null());
            assert_eq!(unsafe { (*cursor).data }, i as *mut c_void);
            unsafe { cursor = (*cursor).next }
        }

        unsafe {
            ft_list_remove_if(
                &mut list,
                TEST_VALUE,
                return_0_if_test_value,
                assert_test_value,
            )
        }
        cursor = list;
        for i in (0..(LIST_LEN - 1)).rev() {
            assert!(!cursor.is_null());
            assert_eq!(unsafe { (*cursor).data }, i as *mut c_void);
            assert_ne!(unsafe { (*cursor).data }, TEST_VALUE);
            unsafe { cursor = (*cursor).next }
        }
        assert!(cursor.is_null());
        assert_eq!(*ASSERT_TEST_VALUE_CALL_COUNT.lock().unwrap(), 1);

        unsafe { ft_list_push_front(&mut list, TEST_VALUE) }
        unsafe {
            ft_list_remove_if(
                &mut list,
                TEST_VALUE,
                return_0_if_test_value,
                assert_test_value,
            )
        }
        cursor = list;
        for i in (0..(LIST_LEN - 1)).rev() {
            assert!(!cursor.is_null());
            assert_eq!(unsafe { (*cursor).data }, i as *mut c_void);
            assert_ne!(unsafe { (*cursor).data }, TEST_VALUE);
            unsafe { cursor = (*cursor).next }
        }
        assert_eq!(*ASSERT_TEST_VALUE_CALL_COUNT.lock().unwrap(), 2);
        assert!(cursor.is_null());

        unsafe { ft_list_remove_if(&mut list, TEST_VALUE, return_0, do_nothing) }
        assert_eq!(*DO_NOTHING_CALL_COUNT.lock().unwrap(), LIST_LEN - 1);
        assert!(list.is_null());

        unsafe { ft_list_remove_if(&mut list, TEST_VALUE, return_0, do_nothing) }
    }
}
