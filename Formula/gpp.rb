class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "http://en.nothingisreal.com/wiki/GPP"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.24.tar.bz2"
  sha256 "9bc2db874ab315ddd1c03daba6687f5046c70fb2207abdcbd55d0e9ad7d0f6bc"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "bbd1b8d52711c816f13638e738a13ddfd0442306fd96e1df6bc8c62adece449d" => :el_capitan
    sha256 "54d8c354f541fa54e94dad303672a4fa6f2b254938d939ee47152a9ea15a0f0f" => :yosemite
    sha256 "11b2c1d47fd6eca609a5eb4c7e88dfd027e476f862a5018d96d60616e6b8e309" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
