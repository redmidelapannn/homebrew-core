class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.14/proteinortho-v6.0.14.tar.gz"
  sha256 "b7653d3b5f71331154625c3d4a62a1ebaf1fa24c77f4e2f3f99fc8c08fe3c743"
  revision 1

  bottle do
    cellar :any
    sha256 "52dcb29deaa45923e07da6f10b83e721ad3cf94740eaf6ef082c758e3337339d" => :catalina
    sha256 "61e698780478495944db5089ea2c1e2d423dc0c85d036beb327a27c46476feab" => :mojave
    sha256 "c3493ea90a145b64f38835d5cbdf3719a290816b16a90af01918a56e10dc46ed" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
