class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.8.tar.gz"
  sha256 "5a235ee2f3065c6cf9479a7c32a11ba3d11f5e185d6c1458a97bd60eb11f88a3"

  bottle do
    sha256 "feb374eb0265136649b3f1b30b120d41f2de4265020ef4f84c04f77b319283e7" => :el_capitan
    sha256 "81a6ec331b5be141948ae3a46bb4954808939d3078ce75345092bc6a3c908b2c" => :yosemite
    sha256 "1bc39d5542413467ecc53212ba53c863fc8b16543b41530b254d841a02979604" => :mavericks
  end

  depends_on "crystal-lang"
  depends_on "readline"

  patch do
    url "https://github.com/greyblake/crystal-icr/commit/25a348bb.patch"
    sha256 "1ed507cdda3635c998e7613e0bb4d4172af73bd7b10431d341c3559e6c01ceb0"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "icr version #{version}\n",
      shell_output("#{bin/"icr"} -v").lines.first
  end
end
