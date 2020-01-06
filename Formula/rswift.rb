class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag      => "v5.0.0",
      :revision => "a5822fdea505b76e8defb78878fde17afac52e38"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd67d96580982d5080a00a464d9d639a71b3f2f0588538f148ad93bb7afa064e" => :catalina
    sha256 "6d474334e3c087215634e9a9796e028aaf4e8302bc5222a888fd603d4af5c633" => :mojave
    sha256 "f935f574d10f63c036eaf8c951c330f7783bccaa865bffb33114ecb42be449e4" => :high_sierra
  end

  depends_on :xcode => "10.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
