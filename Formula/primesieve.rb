class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://dl.bintray.com/kimwalisch/primesieve/primesieve-5.7.0.tar.gz"
  sha256 "4a3e542dd3079dd9c0caf2d67fbb7b79757f65d705bdc8cf50555e65653fa1d1"

  bottle do
    cellar :any
    sha256 "b7b5b03ab3c266646c5204390c9bb87dcf277a80853d6e69d5416f77722386f5" => :el_capitan
    sha256 "37807685a64d9f3ff6ec39769b8609db24c63a6ad3584ba825cd5fa9934647ab" => :yosemite
    sha256 "a9c2ffee2b6c72bb1ee0ffc9bd81b40e45227b4e57950923635e65e8f5f24c72" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
