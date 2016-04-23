class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  homepage "https://web.archive.org/web/20120225123719/http://www.nog.net/~tony/warez/cowsay.shtml"
  url "http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/c/cowsay/cowsay_3.03.orig.tar.gz"
  sha256 "0b8672a7ac2b51183780db72618b42af8ec1ce02f6c05fe612510b650540b2af"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "2a0771aa3e2c302e2d90fb6a28ca670842e3058fbcb677f4e615ab44e46b23f0" => :el_capitan
    sha256 "7b85afd8e429a695a69b681d28bdc3825f1a4a597f31c621cfd475926cb82547" => :yosemite
    sha256 "636acdfa480dd5475615c2ec6fbb66b8c940a7a3408ff47585909d6ebf649128" => :mavericks
  end

  # Official download is 404:
  # url "http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz"

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
    (pkgshare/"hello_world.txt").write("Mooooo!")
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
