class Millw < Formula
  desc "Mill wrapper script, automatically fetch and execute mill"
  homepage "https://github.com/lefou/millw"
  url "https://raw.githubusercontent.com/lefou/millw/master/millw"
  version "1.0"
  sha256 "00528ff087739f2fc5e8b43d2f376ebb8eb30bd745bcdd69283a108968a42580"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f53b42c59f06e7feee6eb6f97c64a7d22445249a504421e7c5aac79b49610b3" => :catalina
    sha256 "1132a6250e1496454369b57a0dd9058934fc23e8f3022134d320d44b0c85697c" => :mojave
    sha256 "aaff7379d1ceb8ef394f4a14160ebb5a2c825ae42a6ad0e2c22fc9550c173400" => :high_sierra
  end

  conflicts_with "mill", :because => "millw is an improved version of the mill starter script"

  resource "bashcompl" do
    url "https://raw.githubusercontent.com/lefou/mill-bash-completion/master/mill.complete.sh"
    sha256 "bf293fbc521cc0c8108cbbc3580adc81cbf470380b4f5cd160af075a5f1214e0"
  end

  def install
    mkdir "bin"
    mv "millw", "bin/mill"
    chmod "u+x", "bin/mill"
    bin.install "bin/mill"
    bash_completion.install resource("bashcompl")
  end

  test do
    system "mill", "--mill-version", "0.5.1-83-6a19be", "version"
  end
end
