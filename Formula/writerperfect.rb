class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.6/writerperfect-0.9.6.tar.xz"
  sha256 "1fe162145013a9786b201cb69724b2d55ff2bf2354c3cd188fd4466e7fc324e6"

  bottle do
    cellar :any
    rebuild 2
    sha256 "b3a48c02b049444bfc485db5e40c3a2503ad579173d61a67e65fd7a1ad09f748" => :high_sierra
    sha256 "49c568d56fbecd3a9b95590bfb018fdd3dfa9c68e77f4f9a654beab0d7a88204" => :sierra
    sha256 "65b0d4a421569d88e4afd7cae5d215d601193f06210ade22fccd9c29ac7b9366" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libodfgen"
  depends_on "libwpd"
  depends_on "libwpg"
  depends_on "libwps"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
