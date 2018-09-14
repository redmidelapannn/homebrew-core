class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.2.tar.gz"
  sha256 "0946f8e82eaf4c51b7f3f2624eef89bfdf73b7c5b04d23aae8d3fbe01cca3ea2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "117ac4553fe8d7b8c6c69b0c7365832b4797f616c2638ca95b141e68b816a6ba" => :mojave
    sha256 "b378edc5c6d2b308f19b4bf95fbae229d23bf0cbeea271eb06acbfc01a29c227" => :high_sierra
    sha256 "dac097d59dc88d4b86c800ec1e11c506ab47d1fd8644b2aa05bfcd663c4c2085" => :sierra
    sha256 "66bbe742792c5f641592ff26674b1776b70c174bb4efca85b7fd8af7c509f5b8" => :el_capitan
  end

  head do
    url "https://github.com/jsummers/imageworsener.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
