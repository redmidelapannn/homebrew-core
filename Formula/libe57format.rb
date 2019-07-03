class Libe57format < Formula
  desc "Library for reading & writing the E57 file format"
  homepage "https://github.com/asmaloney/libE57Format"
  url "https://github.com/asmaloney/libE57Format/archive/v2.0.1.tar.gz"
  sha256 "35a8e2990ad51623373a55dc63f8af997debc5c77703594c6b9b6fb4e08e1052"
  bottle do
    cellar :any_skip_relocation
    sha256 "88cf82fc93ab7416a61a62e5cc6d819a43eaa601377dfbaeff2354f52cd8fdcc" => :mojave
    sha256 "19ddf5c41f0f96ed7b97a181d753b36d7d9e34cce4ae03bcff16fe61b973287a" => :high_sierra
    sha256 "f3c2dcb761b8838f5c5c391116428813f21cffbc6f7a78762bbca0fdf7f25c23" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "xerces-c"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libE57Format`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
