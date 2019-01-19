class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f9539ac382bb5bf57199dbfbec48047590582532b5f54340a69e28552109d906" => :mojave
    sha256 "739b68d44bc61c6ed257ef1393f48cfe768d971788f3758605af1a63d7c3a0b1" => :high_sierra
    sha256 "003ca44693a72492e538f915b9cd862f4637e673d55610b9e40eb2718cd8f8d2" => :sierra
  end

  depends_on "coreutils"
  depends_on "python"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
