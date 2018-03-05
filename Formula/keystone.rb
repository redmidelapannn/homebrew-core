class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.1.tar.gz"
  sha256 "e9d706cd0c19c49a6524b77db8158449b9c434b415fbf94a073968b68cf8a9f0"
  head "https://github.com/keystone-engine/keystone.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "06c5d18dc1fc8a09ea7342ba16c720eb65e9bf6e9bd9929701239924fd3a6c47" => :high_sierra
    sha256 "1308660dccc884f14a1184c8435ca2f7d0d3e3adb2e0073800297a6976fd2faa" => :sierra
    sha256 "7eabb20d599bec123962411847d9e149c1981646e630221beb14ac3928f7fa0b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
