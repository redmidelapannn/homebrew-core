class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libunwind/libunwind-35.4.tar.gz"
  sha256 "5ca0fcb257a33eb376b19cd26ddc5f34d00f9099c8ffb462d7484bfdca654d7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6403fb748f05ea40778c706e3ca73d086799080c935ac8b013122454806c3d77" => :catalina
    sha256 "6403fb748f05ea40778c706e3ca73d086799080c935ac8b013122454806c3d77" => :mojave
    sha256 "6403fb748f05ea40778c706e3ca73d086799080c935ac8b013122454806c3d77" => :high_sierra
  end

  keg_only :provided_by_macos,
    "this formula includes official development headers not installed by Apple"

  def install
    include.install Dir["include/*"]
    (include/"libunwind").install Dir["src/*.h*"]
    (include/"libunwind/libunwind_priv.h").unlink
  end
end
