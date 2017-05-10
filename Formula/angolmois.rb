class Angolmois < Formula
  desc "BM98-like rhythm game"
  homepage "https://mearie.org/projects/angolmois/"

  stable do
    url "https://github.com/lifthrasiir/angolmois/archive/angolmois-2.0-alpha2.tar.gz"
    version "2.0.0alpha2"
    sha256 "97ac3bff8a4800a539b1b823fd1638cedbb9910ebc0cc67196ec55d7720a7005"
    depends_on "sdl"
    depends_on "sdl_image"
    depends_on "sdl_mixer" => "with-smpeg"
    depends_on "smpeg"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "4e50635e1ec8480b7b228c93c6c184f2c61379e3c5a6745655e116fdf995f8c4" => :sierra
    sha256 "d4a94b795443d5b3d898fc76e41266da0c77caee265b3032410c58c792e8ad55" => :el_capitan
    sha256 "968539f2aac22d6ac2e3d7980cd3010efdca9cf36fa984dccb2773e056a290c7" => :yosemite
  end

  head do
    url "https://github.com/lifthrasiir/angolmois.git"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_mixer" => "with-smpeg2"
    depends_on "smpeg2"
  end

  depends_on "pkg-config" => :build

  def install
    system "make"
    bin.install "angolmois"
  end

  test do
    assert_equal version.to_s, /Angolmois (\d+\.\d+(?:\.\d+)?) (\w+) (\d+)?/.match(shell_output("#{bin}/angolmois --version")).to_a.drop(1).join
  end
end
