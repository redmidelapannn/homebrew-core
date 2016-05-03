class Cowsay < Formula
  desc "Talking cows, moooo! (DUMMY DESCRIPTION CHANGE)"
  homepage "https://web.archive.org/web/20120225123719/http://www.nog.net/~tony/warez/cowsay.shtml"
  url "http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/c/cowsay/cowsay_3.03.orig.tar.gz"
  sha256 "0b8672a7ac2b51183780db72618b42af8ec1ce02f6c05fe612510b650540b2af"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "d0241ac6f65b732c268f47fa682e8796e06fb6cc1c06a65f9d0ef56acce033a7" => :el_capitan
    sha256 "90f1f87d3016122f0299fd5bce323b58bf4f0904a587a4c24e9b626cb4f5d83a" => :yosemite
    sha256 "d62ffa8262d21af46c2fd68eaac6363cf993b49eedba7b95a13b57a66f0dba16" => :mavericks
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
