class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/pornel/giflossy/archive/lossy/1.82.1.tar.gz"
  sha256 "a0d048f0c2274c81532a988d2f3ea16c3f1cbb6878f13deeb425d34826e4ed23"
  head "https://github.com/pornel/giflossy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "411193569aa8d8f8200cbc43f417f332230fa0271f377f8a14395d150876da7b" => :sierra
    sha256 "26ea955b3b78516ba342f9b77c2180994582add5be2d72e873dfa7b7431101d2" => :el_capitan
    sha256 "e7ab3470f7b338424c9657d4ffec19aae23b9fa0d8e076ff0ce019c047a917ff" => :yosemite
  end

  option "with-x11", "Install gifview"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11 => :optional

  conflicts_with "gifsicle",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "-O3", "--lossy=80", "-o",
                           "out.gif", test_fixtures("test.gif")
  end
end
