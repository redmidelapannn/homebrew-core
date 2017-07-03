class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag => "v0.3.1",
      :revision => "d796fb0d04882dc31862a808e2cff03ff829b56a"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "f6741beedb7040da5a243240f3f3ad5e71aa68847557d4e1ffedfb41a85f26c2" => :sierra
    sha256 "d2303fdd0d46a398db6d8d8e97d8f7c3fe22c9bd561774e7414b960eaaa59d5b" => :el_capitan
    sha256 "1feeec4d8c59406327734d0aacfaddcf952432f763935ec82763054fd4d22290" => :yosemite
  end

  depends_on "dmd" => :build

  def install
    rm_rf "libdparse/experimental_allocator" if build.stable?
    system "make"
    system "make", "test"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system "#{bin}/dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end
