class Cabocha < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  # Files are listed in https://drive.google.com/drive/folders/0B4y35FiV1wh7cGRCUUJHVTNJRnM
  url "https://dl.bintray.com/homebrew/mirror/cabocha-0.69.tar.bz2"
  mirror "http://netbsd3.cs.columbia.edu/pub/pkgsrc/distfiles/cabocha-20160909/cabocha-0.69.tar.bz2"
  sha256 "9db896d7f9d83fc3ae34908b788ae514ae19531eb89052e25f061232f6165992"

  bottle do
    rebuild 1
    sha256 "eb67dc968048136aacf697fe24bc8c80a818a711ee41aa5d7088c12432a8327c" => :sierra
    sha256 "d027bd2d54a391ea99625d4ba4c5f4c6db26303ab8231267b9381f7a44892464" => :el_capitan
    sha256 "578c61fe0ab60e086209118289a9c94cd71efae910fc177a4dfe65f5987eb829" => :yosemite
  end

  option "with-charset=", "choose default charset: EUC-JP, CP932, UTF8"
  option "with-posset=", "choose default posset: IPA, JUMAN, UNIDIC"

  deprecated_option "charset=" => "with-charset="
  deprecated_option "posset=" => "with-posset="

  depends_on "crf++"
  depends_on "mecab"

  # To see which dictionaries are available, run:
  #     ls `mecab-config --libs-only-L`/mecab/dic/
  depends_on "mecab-ipadic" => :recommended
  depends_on "mecab-jumandic" => :optional
  depends_on "mecab-unidic" => :optional

  def install
    ENV["LIBS"] = "-liconv"

    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cflags
    end

    charset = ARGV.value("with-charset") || "UTF8"
    posset = ARGV.value("with-posset") || "IPA"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-posset=#{posset}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    result = `echo "CaboCha はフリーソフトウェアです。" | cabocha | md5`.chomp
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result
  end
end
