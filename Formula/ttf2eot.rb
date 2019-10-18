class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://github.com/wget/ttf2eot"
  url "https://github.com/wget/ttf2eot/archive/v0.0.3.tar.gz"
  sha256 "f363c4f2841b6d0b0545b30462e3c202c687d002da3d5dec7e2b827a032a3a65"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8d8967fef8cd57d8232d0786e3e05dbed719858e9f34715b300e12a102094e8f" => :catalina
    sha256 "86ce34888f43ec26b543b738b818a3fa638367d967185acf3d452938a2f51d6e" => :mojave
    sha256 "aa253ec8ae9652509eb22aadb2a49fc1b5ffc736f5c268a57406c92a3f2a75ad" => :high_sierra
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    cp "/Library/Fonts/#{font_name}", testpath
    system("#{bin}/ttf2eot < '#{font_name}' > Arial.eot")
    assert_predicate testpath/"Arial.eot", :exist?
  end
end
