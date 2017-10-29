class Ydcv < Formula
  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.4.tar.gz"
  sha256 "2d9f6309bbf2d35c0c34c5ee945cf40769cc8201e6f374fa2a4f2d4b827fbdbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "04e19fd5a9cacf826f54b5eae958de8bd2e3d4bcdabb299288b451bbb6bb1ebe" => :high_sierra
    sha256 "04e19fd5a9cacf826f54b5eae958de8bd2e3d4bcdabb299288b451bbb6bb1ebe" => :sierra
    sha256 "04e19fd5a9cacf826f54b5eae958de8bd2e3d4bcdabb299288b451bbb6bb1ebe" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "ydcv.py" => "ydcv"
    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
  end

  test do
    assert_match "hello", shell_output("#{bin}/ydcv 你好")
    assert_match "你好", shell_output("#{bin}/ydcv hello")
  end
end
