use std::process::Command;

fn main() {
    let output = Command::new("make")
        .current_dir("..")
        .output()
        .expect("failed to run make");
    if !output.status.success() {
        panic!("make failed!\n{output:?}");
    }

    println!("cargo:rustc-link-search=..");
}
