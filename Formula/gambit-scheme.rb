class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  revision 1

  bottle do
    rebuild 1
    sha256 "0681da19c045ef0986750a851ec39b9a7a6c80d17628d742de53bb6571c5bbba" => :catalina
    sha256 "57e9daea4039825a0558a2d5a65c7a10f002c317f5e69de9c3b0646faf077c4e" => :mojave
    sha256 "13d3510a3b60167cd9a24c88301e996a332af27dccee17816472c02d538e7901" => :high_sierra
  end

  depends_on "openssl@1.1"

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
