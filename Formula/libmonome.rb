class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/releases/download/v1.4.0/libmonome-1.4.0.tar.bz2"
  sha256 "0a04ae4b882ea290f3578bcba8e181c7a3b333b35b3c2410407126d5418d149a"

  head "https://github.com/monome/libmonome.git"

  bottle do
    rebuild 1
    sha256 "6547d24f177239d05a814349b21f43b9ba553e8de1772abbcb48deae68aaa1ce" => :sierra
    sha256 "6484a7a881f0b802f39e75149145e6c9530847e782a4912de3121c3a399924a0" => :el_capitan
    sha256 "859b429632f0995e4f9aca9ceb67ba0cff280a506638b3f3b7c05ad55afe7bce" => :yosemite
  end

  depends_on "liblo"

  def install
    inreplace "wscript", "-Werror", ""
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
