class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.0.tar.gz"
  sha256 "946cf3421ffd418f0edc380d1184e4cb08c2ec7f098c79b1c8a2c482fe91d877"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f5af573975fdce92059866e5e196c3daa6395e23744bcac7078d1d3fae2e5f99" => :catalina
    sha256 "77f9ef22debbfeddddd662d5007ce5f1a8b6cca5033397ab3dc4b07ae8c4e6ce" => :mojave
    sha256 "5516a6112cb194b42529fe5cced4e6be26b1b2afac93cb4e42067f579f47534a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build

  # GHC 8.8 compatibility. Remove with the next release.
  patch do
    url "https://github.com/koalaman/shellcheck/commit/2c026f1ec7c205c731ff2a0ccd85365f37245758.patch?full_index=1"
    sha256 "21d76e62f16b12518a2cb30fd1450d1f68bf14e164ec0689732e5ed5b97c656f"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "pandoc", "-s", "-f", "markdown-smart", "-t", "man",
                     "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
