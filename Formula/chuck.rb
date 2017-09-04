class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.2.tgz"
  sha256 "e900b8545ffcb69c6d49354b18c43a9f9b8f789d3ae822f34b408eaee8d3e70b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2792f4843fc3187d35b3a066bd38a577114ee057dd8cfa0b17c49064a6383272" => :sierra
    sha256 "4b8e0e73045fe0e9e96ffdd273c140fd2f4ae8c3dee1f115916712218eb6c7ac" => :el_capitan
    sha256 "45c7e63fc0e0127d775b3cf0a23a4195a1e253f8a2352c7aafb08bc608341fd0" => :yosemite
  end

  depends_on :xcode => :build

  # Fix pointer comparison error with Xcode 9
  # Reported by email to chuck-dev@lists.cs.princeton.edu on 2017-09-04
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b052485f5d/chuck/xcode9.patch"
      sha256 "fa2e008c8d90321c8876a49f83d7566dead362740711442f8e983d07e98a220b"
    end
  end

  def install
    # issue caused by the new macOS version, patch submitted upstream
    # to the chuck-dev mailing list
    inreplace "src/makefile.osx", '10\.(6|7|8|9|10|11)(\\.[0-9]+)?', MacOS.version
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end
