class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.1.tar.gz"
  sha256 "feafbb1d2515bd5dd80b6408d6611549ea22c4366687883b92f706dfd2df596a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8698777a23d7603bd6eacef4c730be2fe6b2312b9bdc9c817779cb258b953998" => :catalina
    sha256 "0f88ee734ebe789b6afe1ab099def0b366d56e1fe5b84d4db296512c6298fa85" => :mojave
    sha256 "0e23844d9069ebc9652fa74f275f1e46b72467eb02f8436a0a1934032a1ad6bc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"berglas"
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
