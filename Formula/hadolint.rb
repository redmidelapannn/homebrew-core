require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.6.tar.gz"
  sha256 "134e8a163745c66b3cc0835c85d3a0546247a15e877d1ce6f9a76d7ab2d47c49"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1a3eb96e8d8b4c7f972d7028feb180ac1d08041c9376553e1be6cf4a8aa2bff0" => :high_sierra
    sha256 "6e9ce514777a670836013018ae23cb01230e61eed6b2fda2d654ce9fcfb6532b" => :sierra
    sha256 "c00da93b9faf8a4250956b545ff026333048f79b5999d7000012022d14273e00" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
    end

    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
