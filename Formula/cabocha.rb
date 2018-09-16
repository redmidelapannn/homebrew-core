class Cabocha < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  # Files are listed in https://drive.google.com/drive/folders/0B4y35FiV1wh7cGRCUUJHVTNJRnM
  url "https://dl.bintray.com/homebrew/mirror/cabocha-0.69.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cabocha-20160909/cabocha-0.69.tar.bz2"
  sha256 "9db896d7f9d83fc3ae34908b788ae514ae19531eb89052e25f061232f6165992"

  bottle do
    rebuild 1
    sha256 "29af96b93b6fb6392bc293fecb661981d9df5d4614962968d96a9872ccc2f0cd" => :mojave
    sha256 "f41546fb09d45bac029bd20594178f76e8d18567b2eca6a4e49514aa6db13a79" => :high_sierra
    sha256 "5935efad8d44e6eef993f419b1d0dc36cbc163bd3a34af52bed4837e37da88f0" => :sierra
    sha256 "c1a44eefcf2f6e3aebda21d9d8b4150adb1d2d25b2d05aa51f55aeadf54b5935" => :el_capitan
  end

  depends_on "crf++"
  depends_on "mecab"
  depends_on "mecab-ipadic"

  def install
    ENV["LIBS"] = "-liconv"

    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cflags
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=UTF8
      --with-posset=IPA
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    result = `echo "CaboCha はフリーソフトウェアです。" | cabocha | md5`.chomp
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result
  end
end
