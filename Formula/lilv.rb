class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.0.tar.bz2"
  sha256 "fa60de536d3648aa3b1a445261fd77bd80d0246a071eed2e7ca51ea91a27fb9e"

  bottle do
    cellar :any
    sha256 "6fe2ded567f15d6650d8114d6f2bfb4f52a5019e9c7236645485dc3d1dae1ac1" => :sierra
    sha256 "195ee6206b8a365b677893fe32a1a31734ed7d35cfc735a3aaf1e837e9124d65" => :el_capitan
    sha256 "cc46f40d6b4f3532a53d1cd6839938774478a2b4975d1dfb233178944f46271e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    lv2info --version
    lv2ls
  end
end
