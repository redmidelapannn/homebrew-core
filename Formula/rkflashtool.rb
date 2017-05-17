class Rkflashtool < Formula
  desc "Tools for flashing Rockchip devices"
  homepage "https://sourceforge.net/projects/rkflashtool/"
  url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-6.1/rkflashtool-6.1-src.tar.bz2"
  sha256 "2bc0ec580caa790b0aee634388a9110a429baf4b93ff2c4fce3d9ab583f51339"

  head "https://git.code.sf.net/p/rkflashtool/Git.git"

  bottle do
    cellar :any
    sha256 "d0e7adc5e3e3927ac5c5ff2a9abd2ef1985bdb2f8bb1fa01d851ee29d941225d" => :sierra
    sha256 "6d7b0b95cb3c59cc17dc7c55364744b5e58985b42b02952704262b9e762dc457" => :el_capitan
    sha256 "f137ff8e2fa7948438aaecc9831c01af1dcac30997e5dcc59ba2438d558ac232" => :yosemite
  end

  depends_on "libusb"
  depends_on "pkg-config" => :build

  def install
    system "make"

    # No 'install' method found in Makefile
    bin.install "rkflashtool", "rkcrc", "rkmisc", "rkpad",
      "rkparameters", "rkparametersblock", "rkunpack", "rkunsign"
  end

  test do
    (testpath/"input.file").write "ABCD"
    system bin/"rkcrc", "input.file", "output.file"
    result = shell_output("cat output.file")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_equal "ABCD\264\366\a\t", result
  end
end
