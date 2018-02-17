class Tractorgen < Formula
  desc "Generates ASCII tractor art"
  homepage "http://www.kfish.org/software/tractorgen/"
  url "http://www.kfish.org/software/tractorgen/dl/tractorgen-0.31.7.tar.gz"
  sha256 "469917e1462c8c3585a328d035ac9f00515725301a682ada1edb3d72a5995a8f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d18d07e73765fb0cf6630ce4e9f27333527db72bdcdcdf261fc98d0f1a3b742" => :high_sierra
    sha256 "79538cf899fb91b982347199a5d7031b90efae3999b2d37b24c41202f4488606" => :sierra
    sha256 "c58f7fb2f22282be8460eaf0caa2f428c9cd39983a793c7ca29b4984b2301fcb" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<~'EOS'.gsub(/^/, "     ") # needs to be indented five spaces
          r-
         _|
        / |_\_    \\
       |    |o|----\\
       |_______\_--_\\
      (O)_O_O_(O)    \\
    EOS
    assert_equal expected, shell_output("#{bin}/tractorgen 4")
  end
end
