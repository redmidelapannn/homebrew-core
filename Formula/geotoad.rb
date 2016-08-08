class Geotoad < Formula
  desc "Query tool to query the geocaching.com website"
  homepage "https://github.com/steve8x8/geotoad"
  url "https://github.com/steve8x8/geotoad/archive/3.25.4.tar.gz"
  sha256 "6c30bb7ce6ae552b4146ac1c228c18c9e3cf318860ff0fc709cee803406ce900"
  head "https://github.com/steve8x8/geotoad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "270856d7cd491b4fb305690a9041a7ea52b10b9653a277db1a22ac29938470e2" => :el_capitan
    sha256 "061a19144c00ff8c720450d5c7f215cdd9ac769f80bbd079ad4823552ea0d694" => :yosemite
    sha256 "040c6dabc5b55c13da2d4be63fa74b5304339eeff6e9b0af2b04b1aff86d2e03" => :mavericks
  end

  def install
    libexec.install %w[data interface lib templates]
    libexec.install "geotoad.rb" => "geotoad"

    bin.write_exec_script libexec/"geotoad"

    doc.install "FAQ.txt", "Templates.txt"
    man1.install "geotoad.1"
  end

  test do
    system "#{bin}/geotoad", "-V"
  end
end
