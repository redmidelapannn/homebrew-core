class Phockup < Formula
  desc "Organize photos and videos in folders by year, month and day."
  homepage "https://github.com/ivandokov/phockup"
  url "https://github.com/ivandokov/phockup/archive/v1.2.0.tar.gz"
  sha256 "8bced90fd663ab9acf8e48e630904da7d493e2fe78add63b0c5d60c18c6de2ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "70f0045add2957f4932e9d1193a7d67b7353880c7a44db7e9173ca58b98cfac6" => :sierra
    sha256 "fe6e2d8b23b47e19d7f54c24a3654e444a853576ff452fca7d8c3796bcbe73a5" => :el_capitan
    sha256 "fe6e2d8b23b47e19d7f54c24a3654e444a853576ff452fca7d8c3796bcbe73a5" => :yosemite
  end

  depends_on "exiftool"
  depends_on "python3"

  def install
    bin.install "phockup.py" => "phockup"
  end

  test do
    assert_match "phockup", shell_output("#{bin}/phockup", 2)
  end
end
