class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.3.tar.gz"
  sha256 "cfa7eeff951e04df428694fda38917ee2aaaf0532e2d1dbea7ab4c150f4fe2f0"
  head "https://github.com/diku-dk/smlpkg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "764defa53ad80c91e06c6441283420a90971ccb73d095feb2688cc0b9a83f139" => :catalina
    sha256 "99fb2219f67e27bbc3d59f115f49d63841eecf0b80142bcbd90c989eaac2280a" => :mojave
    sha256 "7e66d64ab4b69870ecce31a0948a8b240de4097e29a64d394cb1ca23874d0a8d" => :high_sierra
  end

  depends_on "mlkit"

  def install
    system "make", "-C", "src", "smlpkg"
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    (testpath/"sml.pkg.ok").write <<~EOS
      package github.com/diku-dk/testpkg

      require {
      }
    EOS
    system "#{bin}/smlpkg", "init", "github.com/diku-dk/testpkg"
    assert_equal "", shell_output("diff sml.pkg sml.pkg.ok")
  end
end
