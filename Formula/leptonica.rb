class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.74.4.tar.gz"
  sha256 "29c35426a416bf454413c6fec24c24a0b633e26144a17e98351b6dffaa4a833b"

  bottle do
    cellar :any
    sha256 "e922de87e804487ef3ec17976aa9e2b132a8442223333c059257c900dc9d2d45" => :sierra
    sha256 "2c2b4bcb4f41dc9d1ceee7cc779004714ff5db25692fd5f5f57f30a368d34c5b" => :el_capitan
    sha256 "ac06d0cf696e1df52c5438cb5bc0e265ddada0a141bcb5749e628ead4024120c" => :yosemite
  end

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "openjpeg" => :optional
  depends_on "webp" => :optional
  depends_on "pkg-config" => :build

  conflicts_with "osxutils",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff giflib].each do |dep|
      args << "--without-#{dep}" if build.without?(dep)
    end
    %w[openjpeg webp].each do |dep|
      args << "--with-lib#{dep}" if build.with?(dep)
      args << "--without-lib#{dep}" if build.without?(dep)
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
    #include <iostream>
    #include <leptonica/allheaders.h>

    int main(int argc, char **argv) {
        std::fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
        return 0;
    }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
