class Tidyp < Formula
  desc "Validate and modify HTML"
  homepage "https://github.com/petdance/tidyp"
  url "https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz"
  sha256 "20b0fad32c63575bd4685ed09b8c5ca222bbc7b15284210d4b576d0223f0b338"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9ef05d25a3ebb96811a0739c469283daa3c9c35c4e5deae9d436557e6b38df2c" => :catalina
    sha256 "a01f77ec9a336284d6fe48ea1893454c84596d18689bbeaab7d21ee3a1d19b87" => :mojave
    sha256 "88fd4274088350a44db2b887736c9a254caf8c1aa6a0cf03cbae0c3f297ccaff" => :high_sierra
  end

  resource "manual" do
    url "https://raw.githubusercontent.com/petdance/tidyp/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
    sha256 "68ea4bb74e0ed203fb2459d46e789b2f94e58dc9a5a6bc6c7eb62b774ac43c98"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Use the newly brewed tidyp to generate the manual
    resource("manual").stage do
      system "#{bin}/tidyp -xml-help > tidyp1.xml"
      system "#{bin}/tidyp -xml-config > tidyp-config.xml"
      system "/usr/bin/xsltproc tidyp1.xsl tidyp1.xml > tidyp.1"
      man1.install gzip("tidyp.1")
    end
  end

  test do
    system "#{bin}/tidyp", "--version"
  end
end
