class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz"
  sha256 "caeb86511e81420eeb454cb5db53f56d96b8451d37d89af6e55b12eb4da1c513"

  bottle do
    cellar :any
    rebuild 1
    sha256 "494c52d8adf4ed6b93bbb15756d54e5377050f75830c2c737b602b2948748f01" => :sierra
    sha256 "ee35167c687b1c57a1eb51e2c77426449c51757e886e155239e9ba26f9a28729" => :el_capitan
    sha256 "9932ae457edc4676e1e48389e9f88b7d0eecffc2563cc2c3764bc78b21e68534" => :yosemite
  end

  option "with-integer-samples", "Build using integer samples? (default is float)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--enable-integer-samples" if build.with? "integer-samples"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /SoundStretch v#{version} -/, shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
