class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.1.tar.gz"
  sha256 "ebc39deec39478df992d91d0447f15951c6950875021748a3b66b2abd0b03a40"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b823a17234b62eb38f51aa810227181f6888fc912d173765044718275c58b27" => :high_sierra
    sha256 "ee01f413a82c41153ffc303c2f130bc4150df1fd8c45a85eafd3b6e15aed5ac4" => :sierra
    sha256 "a9ae23c9729685c0b0d190034108836adc2ee53b4cef213902ffc2f453b7d712" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/go.mozilla.org").mkpath
    ln_s buildpath, "src/go.mozilla.org/sops"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
