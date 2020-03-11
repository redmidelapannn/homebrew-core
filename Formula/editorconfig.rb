class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.3.tar.gz"
  sha256 "64edf79500e104e47035cace903f5c299edba778dcff71b814b7095a9f14cbc1"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0c7e428c7a4be374249efc6d861b5242f9514b7400af86aaf5ae7fb6d2c625e0" => :catalina
    sha256 "e4ae2ae6507bc76eb0a2171b42f4d0711b6525fb3ea2d289c3c8db2257411366" => :mojave
    sha256 "e9717a42cfcf556bf5df1cd683336498832adb5c7c99496c951dff014f81661f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
