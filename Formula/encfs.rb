class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.2.tar.gz"
  sha256 "cd9e972cd9565cdc26473c86d2c77c98de31fc6f604fa7d149dd5d6e35d46eaa"
  head "https://github.com/vgough/encfs.git"

  bottle do
    rebuild 1
    sha256 "6174292d34f0a35932b16770e50c6a17bea43246fa99b38758fb0f6a92f5c9bd" => :sierra
    sha256 "42052a1a845400b2ef6d7d86f18072173fa283902b18cab902c2ea07e8d528ec" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append "CMAKE_LIBRARY_PATH", "/usr/local/lib", ":"

    args = std_cmake_args
    args << "-DFUSE_INCLUDE_DIR=/usr/local"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
