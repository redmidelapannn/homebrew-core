class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.11.0.tar.gz"
  sha256 "000b873f239e8c5219ede3fd5836d6346ebea64ea928e2d754cdfc0f2071a874"

  bottle do
    rebuild 1
    sha256 "03eba51c86a4ae94183172912cd40b1b15198903453af8e192e3164782a4464d" => :high_sierra
    sha256 "c7aa37593c5600bae63f6b16289de7616beba9a7e2199785ce4be74273e77c88" => :sierra
    sha256 "06b3cb155aec5755843a09aac2ef42b57043c5d946a02215da2c6b4b93fc933f" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--root", prefix
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
