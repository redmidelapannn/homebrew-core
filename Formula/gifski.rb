class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.2.tar.gz"
  sha256 "d7bf1b6515c273b822c94fc78e6d10fbc45d444a04bc3487fe3e799d6aa836e0"

  bottle do
    rebuild 1
    sha256 "80cf05fe2a2ed68f82b238dd51359435aa8922ac9c0b25b4fca375315cbd6539" => :high_sierra
    sha256 "14521854f9778e885e0b294b412bfb8147c1e3f712e1e629275cb60a30f894b3" => :sierra
    sha256 "57911e34e3275a58df3fe2da360a76e2c3a987a9d1d81aa2599ba8595ba946bf" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gcc" if build.with? "openmp"

  fails_with :clang if build.with? "openmp"

  def install
    args = ["--release"]

    if build.with? "openmp"
      args << "--features=video,openmp"
    else
      args << "--features=video"
    end

    system "cargo", "build", *args
    bin.install "target/release/gifski"
  end

  test do
    system bin/"gifski", "-o", "out.gif", test_fixtures("test.png")
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
