class Nylon < Formula
  desc "Proxy server"
  homepage "https://github.com/smeinecke/nylon"
  url "https://monkey.org/~marius/nylon/nylon-1.21.tar.gz"
  sha256 "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4"

  bottle do
    revision 1
    sha256 "0c657dbac21a72af6fd3bfa839f188ed5b3bf223271ca6245a168f24f64cf982" => :el_capitan
    sha256 "165e92dcc5d247c209cba9e2a1c9603a77a90084adf8fbe5d51664c637ed24a6" => :yosemite
    sha256 "64f9e103321f18143031cc256079506777d5a5dcf887c81c6fba8358dd9ac6d9" => :mavericks
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    assert_equal "nylon: nylon version #{version}",
      shell_output("#{bin}/nylon -V 2>&1").chomp
  end
end
