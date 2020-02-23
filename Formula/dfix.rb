class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag      => "v0.3.5",
      :revision => "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4d374b959747ba302699a442882a2ff67fc4bde06048acceb7fe2105104504ba" => :catalina
    sha256 "ccf6a607699002671d6e90795cdf6118fe8d92a2b5853ffd4e9a3c8c9f695b77" => :mojave
    sha256 "f24878d02d6f4506aa93e43cc6ecb90afb1ac8db0e9668058e394054a6e0ea09" => :high_sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
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
