use std::process::Command;

fn main() {
    println!("cargo:rerun-if-changed=../libasm.a");

    let output = Command::new("make")
        .current_dir("..")
        .output()
        .expect("failed to run make");
    if !output.status.success() {
        panic!("make failed!\n{output:?}");
    }

    println!("cargo:rustc-link-search=..");
}
