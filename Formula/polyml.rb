class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.tar.gz"
  sha256 "6bcc2c5af91f361ef9e0bb28f39ce20171b0beae73b4db3674df6fc793cec8bf"
  head "https://github.com/polyml/polyml.git"

  bottle do
    rebuild 1
    sha256 "2eb02b7346763ed164ceb20ef11e6ee7fc5687a2ca71b6870caa1cec5916fc7f" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
