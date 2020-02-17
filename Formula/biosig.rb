class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig4c%2B%2B-1.9.5.src.tar.gz"
  sha256 "20e72a5a07d1bf8baa649efe437b4d3ed99944f0e4dfc1fbe23bfbe4d9749ed5"

  bottle do
    cellar :any
    sha256 "6f798ef1894353d5037a79eec0dfe70a3e388fe83ebc80f3f3b28426c2a15619" => :catalina
    sha256 "58873353d0a64104a4372738d303d56e604575c7fc09efdad3a54badc6c3d3b1" => :mojave
    sha256 "9a6a77889818ca182474e2b43309e26f49f6b231768a2471e4b1a319cdf9918b" => :high_sierra
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "gnu-tar" => :build
  depends_on "pkg-config" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  resource "test" do
    url "https://pub.ist.ac.at/~schloegl/download/TEST_44x86_e1.GDF"
    sha256 "75df4a79b8d3d785942cbfd125ce45de49c3e7fa2cd19adb70caf8c4e30e13f0"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data", shell_output("#{bin}/biosig_fhir 2>&1").strip
    testpath.install resource("test")
    assert_match "NumberOfChannels", shell_output("#{bin}/save2gdf -json TEST_44x86_e1.GDF").strip
    assert_match "NumberOfChannels", shell_output("#{bin}/biosig_fhir TEST_44x86_e1.GDF").strip
  end
end
