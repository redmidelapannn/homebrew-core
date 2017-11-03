class Mashmap < Formula
  desc "Fast and approximate long read mapper"
  homepage "https://github.com/marbl/MashMap"
  bottle do
    cellar :any
    sha256 "4eccc189d120005e47ebfabc0f79bdbdc3f28e9a8518cb8a0e7a8d908be7ab20" => :high_sierra
    sha256 "4eccc189d120005e47ebfabc0f79bdbdc3f28e9a8518cb8a0e7a8d908be7ab20" => :sierra
    sha256 "de75a3b41a232f09713ab27f4a62f71aae6545da2456af42a95932ecb65893e3" => :el_capitan
  end

  # tag "bioinformatics"
  # doi "10.1101/103812"

  url "https://github.com/marbl/MashMap/archive/v1.0.tar.gz"
  sha256 "9bbe14deb8cbc9a64ff43263e12c16677666333ec493d147757130da5ca64c9f"
  head "https://github.com/marbl/MashMap.git"

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "gsl"
  depends_on "zlib"

  def install
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}"
    system "make"
    bin.install "mashmap"
    doc.install %w[README.md LICENSE.txt]
  end

  test do
    system bin/"mashmap", "--help"
  end
end
