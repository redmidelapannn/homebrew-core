class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.20.tar.gz"
  sha256 "8102b48b2c82be6be14633e76e71e215aab5221198315436f97be53e1abe1f5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4ee9f68494a6d784c45147073841beee04950a1db79ff31ad764eea1a2ff4df" => :catalina
    sha256 "e44ea51b2e22ce6e25401d6c03d27074e4282a91ab293a9294cf67ce02e1f87e" => :mojave
    sha256 "aba32ac9ec1ebb45106be00c2e0308d41f6785d9ffa09104f1cbc88ba4ee1e53" => :high_sierra
  end

  resource "vc" do
    url "https://github.com/vlang/vc/archive/0.1.20.tar.gz"
    sha256 "5b4fc1f39c3aef5214a3366e0d514ee2879a2e52a918dc0181df833028a0eb72"
  end
  
  def install
    resource("vc").stage do
      system ENV.cc,"-std=gnu11","-w","-o","v","v.c","-lm"
      libexec.install "v"
    end
    libexec.install "vlib","compiler","examples","thirdparty","tools"
    bin.install_symlink libexec/"v"
  end

  test do
    (testpath/"hello-v.v").write <<~EOS
      fn main() {
        println('Hello, world!')
      }
    EOS
    system "#{bin}/v", "-o", "hello-v", "hello-v.v"
    assert_equal "Hello, world!\n", `./hello-v`

    #need https://github.com/vlang/v/commit/fa7e0ce58a731d393e633b68a0710c7d1e27543f to be released
    #shell_output("#{bin}/v test v")
  end
end
