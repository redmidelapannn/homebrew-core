class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2"
  sha256 "a1b8033f1a1fd6385f4820b01ee32d8eca818409235d22caf5119e0078c7525b"

  bottle do
    cellar :any
    rebuild 4
    sha256 "473e761067011d8aa0f6a33a7258373a0c1eda12f7d5cfe844cdfbd211a4bf09" => :sierra
    sha256 "c4edb839c4f7b1dccd86e1d2191dab56bae2024270e6532150780aadc1936fc9" => :el_capitan
    sha256 "2410d034bc66e3046a30215309d5ada05eb26cdc9f3abface250ecc9e8b334b2" => :yosemite
  end

  option "with-sdl", "Enable SDL usage and create SDL_rwops_zzip.pc"

  deprecated_option "sdl" => "with-sdl"

  depends_on "pkg-config" => :build
  depends_on "sdl" => :optional

  def install
    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-sdl" if build.with? "sdl"
    system "./configure", *args
    system "make", "install"

    ENV.deparallelize # fails without this when a compressed file isn't ready
    system "make", "check" # runing this after install bypasses DYLD issues
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
