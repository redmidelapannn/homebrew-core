class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "950f9e3f42ec5217a9879930af4a94d0fcf4b34306b2b5b5f78ad4f3cade2b39" => :catalina
    sha256 "ad9d8def035a0d7aea6d418238f8a0dea0a0263cf9d9a3cf264d138df49c59d1" => :mojave
    sha256 "adcf33748b44f62740f0cbf53a98bb392e970f7bae7960b37c1c35de9dcdfda7" => :high_sierra
  end

  # Fix build issues issue on OS X 10.9/clang
  # Patch reported to upstream - https://sourceforge.net/p/yconalyzer/bugs/3/
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/yconalyzer/1.0.4.patch"
    sha256 "a4e87fc310565d91496adac9343ba72841bde3b54b4996e774fa3f919c903f33"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    chmod 0755, "./install-sh"
    system "make", "install"
  end
end
