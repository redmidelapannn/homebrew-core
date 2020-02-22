class Openmittsu < Formula
  desc "Cross-platform GPLv2 desktop client for the Threema Messenger App"
  homepage "https://github.com/blizzard4591/openMittsu"
  url "https://github.com/blizzard4591/openMittsu/archive/0.9.15.tar.gz"
  sha256 "7c70de775716f8c01c6f6f4c812fd938f2aea979f6fe4562bb6a4089fa3b9cae"
  head "https://github.com/blizzard4591/openMittsu.git", :using => :git, :shallow => false

  bottle do
    sha256 "1a67d79a452a87b9e460de2ce318445c2b3274f675b450b54b2dcaa91a8dbe49" => :catalina
    sha256 "904171b5b3a97e5c980b71dba6024bc333c7ecea4bb355c0de0ca3902c8daa87" => :mojave
    sha256 "8c1bef460c6748be6d982f193a8d5b84e0ef1746a2cb50d23fc406f5510cb272" => :high_sierra
  end

  depends_on "blizzard4591/homebrew-qt5-sqlcipher/qt5-sqlcipher"
  depends_on "cmake"
  depends_on "libsodium"
  depends_on :macos => :mavericks
  depends_on "pkg-config"
  depends_on "qrencode"
  depends_on "qt"
  depends_on "spdlog"

  def install
    args = %w[
      -DOPENMITTSU_DEBUG=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
      -DOPENMITTSU_DISABLE_VERSION_UPDATE_CHECK=On
    ]

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/openMittsuTests", 1)
  end
end
