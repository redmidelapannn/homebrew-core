class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  homepage "https://web.archive.org/web/20120225123719/http://www.nog.net/~tony/warez/cowsay.shtml"
  url "http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/c/cowsay/cowsay_3.03.orig.tar.gz"
  sha256 "0b8672a7ac2b51183780db72618b42af8ec1ce02f6c05fe612510b650540b2af"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "62c28a8d0afe885421f374d1158c8944af2f0407c457c3c3da81935a295ea6a0" => :el_capitan
    sha256 "1a6ebde407148a338a410f83ceb2e4470cce147191bd85ca2fd1d291633b0314" => :yosemite
    sha256 "8b318fdd4ad0c5a4eb1bfab861838b9f270948ee79ae154216fb02d239604e81" => :mavericks
  end

  # Official download is 404:
  # url "http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz"

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
