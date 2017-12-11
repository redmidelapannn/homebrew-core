class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libmad/0.15.1b/libmad-0.15.1b.tar.gz"
  sha256 "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690"

  bottle do
    cellar :any
    rebuild 2
    sha256 "1d4e5dde92207dd577b6a5a05183778f187a8b5c22e46fae6aece6cb47ee5149" => :high_sierra
    sha256 "2da5b805f025076b85d7e5c0bab55463eace09f86c2da8255bc5c4217c50def7" => :sierra
    sha256 "1a35e3c580fbeb2202f2b4e2ce10fc07170242a07742b79d5e5e09512e86cac1" => :el_capitan
  end

  def install
    fpm = MacOS.prefer_64_bit? ? "64bit": "intel"
    system "./configure", "--disable-debugging", "--enable-fpm=#{fpm}", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
    (lib+"pkgconfig/mad.pc").write pc_file
  end

  def pc_file; <<~EOS
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: mad
    Description: MPEG Audio Decoder
    Version: #{version}
    Requires:
    Conflicts:
    Libs: -L${libdir} -lmad -lm
    Cflags: -I${includedir}
    EOS
  end
end
