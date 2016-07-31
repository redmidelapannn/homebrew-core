class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta/archive/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"

  bottle do
    cellar :any
    revision 1
    sha256 "b898e40a609fe093644cd91babc1bfb75e774fa9c2a258d9e51beb6b0900cc03" => :el_capitan
    sha256 "2ebc2a63d2c2565c850fe79cc488306da0deedac8ff47bc979939102028c17fe" => :yosemite
    sha256 "092e9dcfea1b8c831b0ff4f6bc088265968909dbb6229fc0c462657fe8b23165" => :mavericks
  end

  option "without-xz", "Disable LZMA secondary compression"

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "xz" => :recommended

  def install
    cd "xdelta3" do
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
      ]

      if build.with? "xz"
        args << "--with-liblzma"
      else
        args << "--with-liblzma=no"
      end

      system "autoreconf", "--install"
      system "./configure", *args
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
