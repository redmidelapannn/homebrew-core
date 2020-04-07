class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.1.tar.gz"
  sha256 "50a219bde5c16fc0a40e2e3725b6c192ff589bc8a2569c32b62dcaece0495896"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7769ec6fdab1c38c4003ee5a481fe8cdca274b251b420f943f9933bc8dc8a24a" => :catalina
    sha256 "699414b5c76c90872c9bca622cd751952e9357906e478ecfd1ce5a229ef14eb6" => :mojave
    sha256 "d5b5256dc342709b92441d4eea93dbc00bbd55a7d321651395c8438615bc84e8" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pandoc" => :build

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
