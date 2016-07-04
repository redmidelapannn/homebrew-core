class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  version "1.4.0"
  sha256 "f5f9a1aea478ee6dbcece8907fd4551058fe72fc2c2a7be972e3d0b7eec4fa43"

  bottle do
    cellar :any
    revision 2
    sha256 "7a10de4c37b10257043cd13494834c77760f79636f3c05671d606573e801db84" => :el_capitan
    sha256 "132e229ef3e424c7a2f20a12c99c2eb5f2038b792b3e70356db1cb496bda3dae" => :yosemite
    sha256 "bd01933de04f933e816b86e9415a083b8392902e64e8bb25d4805494f5fc9334" => :mavericks
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/"test.dts").write <<-EOS.undent
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
