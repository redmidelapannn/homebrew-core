class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  bottle do
    rebuild 2
    sha256 "95f357045547bed9d450b5482f2078c45f23b39198df475f4ae3a71f83a4dd63" => :mojave
    sha256 "218116b06dac337787293f79683e29e36a1d1fc5a016bba54528ad62861e54ad" => :high_sierra
    sha256 "c66c770c035326959643efaa438a5863913e55ea5f280c7403ce3095778c3676" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
