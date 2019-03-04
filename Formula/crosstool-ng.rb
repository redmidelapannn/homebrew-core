class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 3
  head "https://github.com/crosstool-ng/crosstool-ng.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e76e8843903036fc734aac5c458690ff7de49521ef28e4794a92df62d0b48e0f" => :mojave
    sha256 "15813e7c961efed78cfee3afd028c8fcaa0c2a96fa111f341a28bdc385f3e3ca" => :high_sierra
    sha256 "3da97c86c15d3810b377ca2f3d5905c9376cabad7929bce2405c0d62805a67d8" => :sierra
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "libtool"
  depends_on "m4"
  depends_on "make"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "xz"

  if build.head?
    depends_on "bash"
    depends_on "bison"
    depends_on "gettext"
    depends_on "lzip"
  end

  def install
    if build.head?
      system "./bootstrap"
      ENV["BISON"] = "#{Formula["bison"].opt_bin}/bison"
      ENV.append "LDFLAGS", "-lintl"
    end

    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "#{Formula["make"].opt_bin}/gmake"

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
