class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.3.tar.gz"
  sha256 "90da5ae9c76c39794cd35cb93a77d24b60b4c4bb55ef8abde95f44991290218c"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "76e7966ed68a076fcf6b8970d7f7a2ab4bbeef5a626f5534de48f820b9f660c3" => :high_sierra
    sha256 "6d653f1647da6201c1be112470800238f422d431de5b2f754197f542049dc66f" => :sierra
    sha256 "d69be10b66498cc72a78c1d713775f556ce0407895053dac18aede4f074c9975" => :el_capitan
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
