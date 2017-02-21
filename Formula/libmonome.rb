class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "http://monome.org/"
  url "https://github.com/monome/libmonome/releases/download/v1.4.0/libmonome-1.4.0.tar.bz2"
  sha256 "0a04ae4b882ea290f3578bcba8e181c7a3b333b35b3c2410407126d5418d149a"

  head "https://github.com/monome/libmonome.git"

  bottle do
    rebuild 1
    sha256 "801869b7a0318b6305516eb9abf4f34db838295a5520ace0a14422638050b7e3" => :sierra
    sha256 "801869b7a0318b6305516eb9abf4f34db838295a5520ace0a14422638050b7e3" => :el_capitan
    sha256 "000531253f6743a8ea1b214dd958fa8e440bc8f1fbf4f9657706ef67519392ef" => :yosemite
  end

  depends_on "liblo"

  def install
    inreplace "wscript", "-Werror", ""
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
