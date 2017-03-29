class Nyancat < Formula
  desc "Renders an animated, color, ANSI-text loop of the Poptart Cat"
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.5.1.tar.gz"
  sha256 "c948c769d230b4e41385173540ae8ab1f36176de689b6e2d6ed3500e9179b50a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "12319e920d8f451e44d1b90fd73be3f4a152c00374e4b74fe212f688e0530bd4" => :sierra
    sha256 "26834a221a96a5b96fb1f87dd39a0a020e932bf46887c300bd419b9f31cd3325" => :el_capitan
    sha256 "b22a9fa3815d5e8f77750f9e3295a11d18950420794044af0db7809b7ce45281" => :yosemite
  end

  # Makefile: Add install directory option
  patch do
    url "https://github.com/klange/nyancat/pull/34.patch"
    sha256 "407e01bae1d97e5153fb467a8cf0b4bc68320bea687294d56bcbacc944220d2c"
  end

  def install
    system "make"
    system "make", "install", "instdir=#{prefix}"
  end

  test do
    system "#{bin}/nyancat", "--frames", "1"
  end
end
