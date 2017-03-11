# Please check & build every `brew uses giflib` locally prior to
# submitting 5.x.x. Many formulae requiring giflib haven't
# updated to use 5.x.x yet.
# Can `brew install homebrew/versions/giflib5` for now.
class Giflib < Formula
  desc "GIF library using patented LZW algorithm"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2"
  sha256 "0ac8d56726f77c8bc9648c93bbb4d6185d32b15ba7bdb702415990f96f3cb766"

  bottle do
    cellar :any
    rebuild 2
    sha256 "37897aa1eaa944717a4fc32177bcd6615c46e8ddab989d90925759294aa47d84" => :sierra
    sha256 "37f9c53e76fc247f222fedb5512c67aef9c285f3b0c81b4395b1564b07bde78d" => :el_capitan
    sha256 "cbd0eb2608599684a29b2e6a66fa076f2cb07cd79d118fcc9c4d1fb87c737635" => :yosemite
  end

  depends_on :x11 => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    if build.without? "x11"
      args << "--disable-x11" << "--without-x"
    else
      args << "--with-x" << "--enable-x11"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /Size: 1x1/, shell_output("#{bin}/gifinfo #{test_fixtures("test.gif")}")
  end
end
