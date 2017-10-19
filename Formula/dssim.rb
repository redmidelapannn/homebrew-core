class Dssim < Formula
  desc "RGBA Structural Similarity C implementation (with a Rust API)"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/1.3.2.tar.gz"
  sha256 "2e79f8cf7cb7681f7f3244364662ce4723739745201217d85243bbc709124e63"

  bottle do
    cellar :any
    rebuild 1
    sha256 "421aa588644564d0fde1f0bf1ec46c32b6bfacb1eda224bc048a0cf3d683c9e9" => :high_sierra
    sha256 "c4da2e03cf2b7131da65e6e299e4e1d86bb32a4fa2a10fef56374c24cee9c561" => :sierra
    sha256 "906f52022c2530dc340712797098a5ae07997f01e3913fa7eb6ab4a45c7f5244" => :el_capitan
  end

  resource "meson-0.27.0" do
    url "https://github.com/mesonbuild/meson/archive/0.27.0.tar.gz"
    sha256 "0ecc660f87d55c3cfee5e8ffd53c91227e3d0c9f0c3b4187cd7e8679e30f2255"
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on :python3
  depends_on "ninja"

  def install
    (buildpath/"mesonbuild").install resource("meson-0.27.0")
    cd buildpath/"mesonbuild" do
      version = Language::Python.major_minor_version("python3")
      ENV["PYTHONPATH"] = buildpath/"meson-0.27.0/lib/python#{version}/site-packages"
      system "python3", "install_meson.py", "--prefix=#{buildpath}/meson-0.27.0"
    end
    ENV.prepend_path "PATH", buildpath/"meson-0.27.0/bin"
    mkdir buildpath/"macbuild" do
      system "../meson-0.27.0/bin/meson", "--prefix=#{prefix}", ".."
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
