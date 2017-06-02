class Phockup < Formula
  desc "Media sorting and backup tool to organize photos and videos from your camera in folders by year, month and day."
  homepage "https://github.com/ivandokov/phockup"
  url "https://github.com/ivandokov/phockup/archive/v1.2.0.tar.gz"
  sha256 "8bced90fd663ab9acf8e48e630904da7d493e2fe78add63b0c5d60c18c6de2ad"

  depends_on "exiftool"

  def install
    bin.install "phockup.py" => "phockup"
  end

  test do
    assert_match "phockup", shell_output("#{bin}/phockup", 2)
  end
end
