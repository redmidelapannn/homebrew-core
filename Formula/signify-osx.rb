class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "https://man.openbsd.org/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.3.tar.gz"
  sha256 "c67090135a55478a6a6c11d507d9c3865a11de665c010a8a5f2457737f277f89"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "17e62ca5739b844ee9bbb16eb9127b2e24ac6ef66e25278a7c3715ba26d8f3ae" => :sierra
    sha256 "3ac3eee8b1e013bb882cf8e4fcad3bf9c7d39921e84fb8dbf6588dc6d519d3d5" => :el_capitan
    sha256 "f5b8de027ff999afeac5250219b058a667ed7260479321a80d8849666d02e78b" => :yosemite
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "pubkey", "-s", "seckey"
  end
end
