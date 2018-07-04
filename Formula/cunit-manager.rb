class CunitManager < Formula
  desc "Full blown c/c++ dependency & tool manager"
  homepage "https://github.com/cunit/cunit"
  url "https://github.com/cunit/cunit/archive/v0.0.9.tar.gz"
  sha256 "e39147b48c8163bbaaa5db908277aa376fec5f3b2a5f5edecd1716ab9a95c66e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0b34a4d1aa7beab42fe36db09a435631615a5d6655a04bcbb54270bd8570485" => :high_sierra
    sha256 "5caac4325cca980636f335cf7f9c0684266721037bada75b0808aa34596a3088" => :sierra
    sha256 "88bd35c77257cd4a0bd4ee021a765e84b9888d1d85eef209a749cbfa8e413a2e" => :el_capitan
  end

  depends_on "node" => :build
  def install
    system "#{HOMEBREW_PREFIX}/bin/npm", "i"
    puts "Buildpath: #{buildpath}"
    system "ls", buildpath
    prefix.install Dir["*"]

    mv bin/"cunit.js", bin/"cunit"
  end

  test do
    system bin/"cunit", "repo", "update"
  end
end
