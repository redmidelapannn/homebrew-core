class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cc6691091d418583070444e754bdd8d2e717ba62f989316ec9ac1250e72947de" => :high_sierra
    sha256 "18f85bede79243cf5f6f5eba54580de7618a89dd5ee1d9dbcafc13cc5c63e319" => :sierra
    sha256 "bf1a79b3e59e0b908297c4985253d5edf3d861278954e07c748bb5006cb40f70" => :el_capitan
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    assert_predicate bin/"naga", :exist?
  end
end
