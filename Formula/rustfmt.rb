class Rustfmt < Formula
  desc "Rust code formatter"
  homepage "https://github.com/rust-lang/rustfmt"
  url "https://github.com/rust-lang/rustfmt/archive/v1.3.2.tar.gz"
  sha256 "d9ff195fa0f02012c0be8aa7b387e2140271809f61f3b621d7228a338670e040"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a856a10e6d2ea8d7e6a965c8211997b448d16d228b5825867720936e6b06f3b" => :mojave
    sha256 "bec73b90c1447dad67342a1c145c34b45b48858ac0193704862782f9a8a563dc" => :high_sierra
    sha256 "d61233c2854e5836ac29e7a49b41799b56340ab2547dffc2d89808ffc51ecddc" => :sierra
  end

  depends_on "rustup-init" => :build

  depends_on "rust"

  def install
    ENV["RUSTUP_HOME"] = buildpath/"rustup"
    ENV["CARGO_HOME"] = buildpath/"cargo"
    system "rustup-init", "--default-toolchain", "nightly", "-y"
    system buildpath/"cargo/bin/cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"Cargo.toml").write <<~EOS
      [package]
      name = "hello"
      version = "0.1.0"
      authors = ["homebrew"]

      [dependencies]
    EOS
    (testpath/"src/main.rs").write <<~EOS
      println!  ( "hello, world" )  ;
    EOS
    system "cargo", "fmt"
    assert_match 'println!("hello, world");', (testpath/"src/main.rs").read
  end
end
