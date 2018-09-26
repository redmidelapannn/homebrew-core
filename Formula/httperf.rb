class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5f4c3cf480eacd7d9ea89535cf6bfbfde0a5cd0ef5cd86cdbe4bc3e59f48d978" => :mojave
    sha256 "7db0d39474f5e3cfc0d09eeabac66f088570228fff3723ff76238fba63c040ee" => :high_sierra
    sha256 "06eebc78c9d522e99783ca69329bdeb15a53386e31008ffaca50261d1bc0f07a" => :sierra
  end

  # Upstream actually recommend using head over stable now.
  head do
    url "https://github.com/httperf/httperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/httperf", "--version"
  end
end
