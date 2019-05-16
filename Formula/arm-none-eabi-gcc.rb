class ArmNoneEabiGcc < Formula
  desc "GNU Embedded Toolchain for ARM"
  homepage "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads"
  url "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-mac.tar.bz2"
  version "8-2018-q4-major"
  sha256 "0b528ed24db9f0fa39e5efdae9bcfc56bf9e07555cb267c70ff3fee84ec98460"

  bottle do
    cellar :any_skip_relocation
    sha256 "58b5d859b8cfe78cfdea9fe3df33e8c6181b7092320d7193d11cd9294cd4c621" => :mojave
    sha256 "58b5d859b8cfe78cfdea9fe3df33e8c6181b7092320d7193d11cd9294cd4c621" => :high_sierra
    sha256 "677e3ca5af06637ac7187066ae349dbc1e795f590f67a54c71595422f996d9d1" => :sierra
  end

  depends_on "expat" => :build
  depends_on "libiconv" => :build
  depends_on "libmpc" => :build
  depends_on "isl" => :build
  depends_on "zlib" => :build
  depends_on "libelf" => :build

  def install
    (prefix/"gcc").install Dir["./*"]
    Dir.glob(prefix/"gcc/bin/*") { |file| bin.install_symlink file }
  end

  test do
    # TODO: try compiling the sample code that comes with the source dist
    # for now, just pass
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS

    shell_output("#{bin}/arm-none-eabi-gcc -c test.c -o test.o")
    assert_equal "test.o: ELF 32-bit LSB relocatable, ARM, EABI5 version 1 (SYSV), not stripped", shell_output("file test.o").strip
  end
end
