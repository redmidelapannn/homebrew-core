class Akku < Formula
  desc "R6RS/R7RS Scheme language package manager"
  homepage "https://akkuscm.org"
  url "https://gitlab.com/akkuscm/akku/uploads/7f36e5a69b24c028d478fdc3c13e7c3d/akku-1.0.1.src.tar.xz"
  sha256 "33d6ca54122bc565b91520006f97f611dc5f5ae2ebcf77953544b50f1b1bd7c7"
  head "https://gitlab.com/akkuscm/akku.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29651b8f56f085c97cb7e9c3dbc3b81e00395cf3920c47bd435284038ae9625a" => :catalina
    sha256 "55f3ebc5030d0c640f846e759d53fbf5618dea3927190269b9587c9a45283885" => :mojave
    sha256 "4f2e20e76f36629870905b168216d1f6b83ba452e0913aee1d8aa050d8061d7a" => :high_sierra
  end

  # TODO: Akku supports both Guile and Chez, but the actual tarball to download is
  # different depending on which you choose for running Akku. I wasn't able to get
  # the Guile version working, so this uses Chez.
  depends_on "chezscheme"

  # XXX: This is effectively a reimplementation of Akku's own install.sh, but running
  # that script via Homebrew fails for me without an error.
  def install
    chez = Formula["chezscheme"].bin/"chez"
    lib.mkpath
    (lib/"akku/bin").mkpath
    (lib/"akku/bin").install Dir["lib/akku/bin/*"]
    (lib/"akku/lib").mkpath
    (lib/"akku/lib").install Dir["lib/akku/lib/*"]
    (lib/"akku/lib/akku.chezscheme").write <<~EOS
      #!/bin/sh
      export CHEZSCHEMELIBDIRS="#{lib}/akku/lib"
      unset CHEZSCHEMELIBEXTS
      exec #{chez} --program "#{lib}/akku/bin/akku.sps" "$@"
    EOS
    ENV["CHEZSCHEMELIBDIRS"] = lib/"akku/lib"
    ENV.delete "CHEZSCHEMELIBEXTS"
    system chez, "--compile-imported-libraries", "--program", lib/"akku/bin/akku.sps"
    bin.mkpath
    bin.install lib/"akku/lib/akku.chezscheme" => "akku"
    man1.install "share/man/man1/akku.1"
  end

  test do
    expected = ",()´ Akku.scm 1.0.1 - Scheme package manager"
    assert_match shell_output("#{bin}/akku --help"), expected
  end
end
