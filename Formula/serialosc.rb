class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
    :tag => "v1.4",
    :revision => "c46a0fa5ded4ed9dff57a47d77ecb54281e2e2ea"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4afe4a2c91b0a6bbe8ed731c51f53b59665f16dc5a1c526a319d0f6eeefff60d" => :el_capitan
    sha256 "6fc0c2500ed852242173cbef3096b060fb0a98fe1b6f56a8af69625d1074df74" => :yosemite
  end

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialosc-device -v")
  end
end
