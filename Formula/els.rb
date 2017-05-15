class Els < Formula
  desc "Displays emoji icons alongside ls output."
  homepage "https://github.com/AnthonyDiGirolamo/els"
  url "https://raw.githubusercontent.com/AnthonyDiGirolamo/els/master/els"
  version "1.0"
  sha256 "93ca8e9f2906cb03ff452f7c4819744983371f7a5a3366d4689fa0fc45906b7e"
  bottle do
    cellar :any_skip_relocation
    sha256 "0013c3ca88a7a8eebeae6965661199bf101fe676cfaff83ed729083a6dcba62e" => :sierra
    sha256 "6eca1e220b8f07076a40be8a768e4b4dde9e4e02feb7dbb04eb139e1d526eff0" => :el_capitan
    sha256 "6eca1e220b8f07076a40be8a768e4b4dde9e4e02feb7dbb04eb139e1d526eff0" => :yosemite
  end

  depends_on :ruby => "1.9"

  def install
    bin.install "els"
  end

  test do
    system "#{bin}/els"
  end
end
