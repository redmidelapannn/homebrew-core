class Rmw < Formula
  desc "OS portable cli trash can utility written in C"
  homepage "https://github.com/andy5995/rmw/wiki"
  url "https://github.com/andy5995/rmw/archive/v0.4.03.tar.gz"
  sha256 "5b08fce4392901d7900bfbd65bd8794a1bf9b6700073bc48ed8e88d6185c4177"
  head "https://github.com/andy5995/rmw.git"

  bottle do
    sha256 "d431d355ab20fe6124bb8b0b62354893c5a4861351cb5713a8e3b836f749eadb" => :high_sierra
    sha256 "7315749e585b5f374236f5153ebf6cbaf864764e8ffeba009aafb291a1bce83f" => :sierra
    sha256 "c8ac56062d138838e1d22a88c057a1a423e9b40834acfafa5d72600f082c5858" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rmw", "-V"
  end
end
