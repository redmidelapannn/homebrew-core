class Cdargs < Formula
  desc "Bookmarks for the shell"
  homepage "https://www.skamphausen.de/cgi-bin/ska/CDargs"
  url "https://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz"
  sha256 "ee35a8887c2379c9664b277eaed9b353887d89480d5749c9ad957adf9c57ed2c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6d3e91a422edb47d16822be3d76d6f4e0806a0153277f6a12c0235637b51bd1a" => :catalina
    sha256 "86a2c2c474e22a93203d2e8bdc39312024c0e0659091a7139fbd86911528d1fb" => :mojave
    sha256 "5f2bf66e072aabe6b8c1b9d680276ca88cc4670d685bb0e61c1da73b5bad7871" => :high_sierra
  end

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See https://www.skamphausen.de/cgi-bin/ska/CDargs)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cdargs/1.35.patch"
    sha256 "adb4e73f6c5104432928cd7474a83901fe0f545f1910b51e4e81d67ecef80a96"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install-strip"

    rm Dir["contrib/Makefile*"]
    prefix.install "contrib"
    bash_completion.install_symlink "#{prefix}/contrib/cdargs-bash.sh"
  end

  def caveats
    <<~EOS
      Support files for bash, tcsh, and emacs have been installed to:
        #{prefix}/contrib
    EOS
  end

  test do
    system "#{bin}/cdargs", "--version"
  end
end
