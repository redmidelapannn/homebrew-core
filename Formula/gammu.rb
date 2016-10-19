class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.90.tar.xz"
  sha256 "f5e9a9ac62e8fa02767c876bd88d3ce10e6e5dcb58aa1182008014e987bcb442"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "38025cb49d74db9a1e44791aaef898f8500577054bd50e3dc7ef4d266e797989" => :sierra
    sha256 "76fe533f4eb78e36ba5ada25a1de8e1f27da462c0b747e38392c094c47c6fed0" => :el_capitan
    sha256 "1b0aacfc163d1d7e9842b1cfa41688c58e4aab1db551f851550d4ad0ed239746" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
