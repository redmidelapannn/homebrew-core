class Wuzz < Formula
  desc "Interactive cli tool for HTTP inspection"
  homepage "https://github.com/asciimoo/wuzz"
  url "https://github.com/asciimoo/wuzz/releases/download/v0.4.0/wuzz_darwin_amd64"
  version "0.4.0"
  sha256 "c8a4bc7eef2511093fd55a1e38b90aeabb4b0016b01875ec143ae19358342470"

  bottle do
    cellar :any_skip_relocation
    sha256 "2caeb0c39355020ef5d3bb08762015c535c88c2d443f08c19c1db65b62058974" => :sierra
    sha256 "2caeb0c39355020ef5d3bb08762015c535c88c2d443f08c19c1db65b62058974" => :el_capitan
  end

  def install
    mv "wuzz_darwin_amd64", "wuzz"
    bin.install "wuzz"
  end

  test do
    assert_match /wuzz #{version}/, shell_output("#{bin}/wuzz --version")
  end
end
