class Shortpath < Formula
  desc "Small utility that will shorthen any path"
  homepage "https://github.com/andreicek/shortpath"
  url "https://github.com/andreicek/shortpath/archive/v1.1.0.tar.gz"
  sha256 "5bfe8b093d93b1db8370aa1a3df6bf79910025f49b5c4451d2ece61b2f13cd7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0518b17961544f6c218b66a90158f4943c78461dac866b97af7107961379069d" => :sierra
    sha256 "3581eb286f974710a78b138f4eada34ccf8858fe461a6572dbd2bcdeb87e6ce2" => :el_capitan
  end

  def install
    system "make"
    bin.install "bin/shortpath"
  end

  test do
    output = `#{bin}/shortpath /hello/world/test`
    assert output == "/h/w/test", "Output is not /h/w/test"
  end
end
