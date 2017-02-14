class Netcat < Formula
  desc "Utility for managing network connections"
  homepage "http://netcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.bz2"
  sha256 "b55af0bbdf5acc02d1eb6ab18da2acd77a400bafd074489003f3df09676332bb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d1a0cc9c535b3aa2a6334811c0911e7b4a1d208f620e14cea2c95766733a3df4" => :sierra
    sha256 "d804466e883d15c2727a7f271a06d2f928846e976dbcbd6167b9c57508ab9724" => :el_capitan
    sha256 "2dec0bedefb5befc9aa01bbf3e5fc0ca984a9524bac43d9a9650c374aa924b2d" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/nc google.com 80", "GET / HTTP/1.0\r\n\r\n")
    assert_equal "HTTP/1.0 200 OK", output.lines.first.chomp
  end
end
