class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.2.tar.gz"
  sha256 "c0a3e612b41f441081098e3f3e1716fc709421f3d17654a9f0303f420fdbc1ee"

  bottle do
    cellar :any
    sha256 "73e9515f275963c99cd6b2973380031c298f886187c274b305a3a43e66d2e4d4" => :catalina
    sha256 "bdf13cd86f609debd443e173adb592eb61084e9c0842405093ab1015669a38c7" => :mojave
    sha256 "20dbd9211441b7039ff831bc68babf390920ecc2c6344e4f0ba05e75583a0a4b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
