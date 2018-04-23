class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.7.2/pjproject-2.7.2.tar.bz2"
  sha256 "9c2c828abab7626edf18e04b041ef274bfaa86f99adf2c25ff56f1509e813772"
  head "https://svn.pjsip.org/repos/pjproject/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9a5ea55b14753a88e6b52bd63042fa2bccaf7798810d0474f18e95c0bba78010" => :high_sierra
    sha256 "02c880ec22a5b1ebe3aa28580c9c54b748ac1950fa9d0346bf3b66f2a2636cdf" => :sierra
    sha256 "24989e2595e0e2fe9af661878a22307f0d74368f4ff84479c6eb1d5824a16b63" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.popen_read("uname -m").chomp
    rel = Utils.popen_read("uname -r").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
