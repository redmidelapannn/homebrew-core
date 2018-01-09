class Zpython < Formula
  desc "Embeds a Python interpreter into zsh"
  homepage "https://bitbucket.org/ZyX_I/zsh"
  head "https://bitbucket.org/ZyX_I/zsh.git", :branch => "zpython"

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2"
    mirror "https://www.zsh.org/pub/old/zsh-5.0.5.tar.bz2"

    # We prepend `00-` for the first version of the zpython module, which is
    # itself a patch on top of zsh and does not have own version number yet.
    # Hoping that upstream will provide tags that we could download properly.
    # Starting here with `00-`, so that once we get tags for the upstream
    # repository at https://bitbucket.org/ZyX_I/zsh.git, brew outdated will
    # be able to tell us to upgrade zpython.
    version "00-5.0.5"
    sha256 "6624d2fb6c8fa4e044d2b009f86ed1617fe8583c83acfceba7ec82826cfa8eaf"

    # Note, non-head version is completly implemented in this lengthy patch
    # later on, we hope to use https://bitbucket.org/ZyX_I/zsh.git to download a tagged release.
    patch do
      url "https://gist.githubusercontent.com/felixbuenemann/5790777/raw/cb5ea3b34617174e50fd3972792ec0944959de3c/zpython.patch"
      sha256 "73d6565536abe269cc7715e5200ba63000b7fb830c8975db7e5e6db2222e8f09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "207555e56d37ecff69efad15dd2e706eb4a8045bc596763efb2edc9d30e225e8" => :high_sierra
    sha256 "d0e4ab7be835f9bdb34eca10a57222d33da3ee276dfe431b85f7cea7acc46fa0" => :sierra
    sha256 "d7d47777de68b374efce2e54db6c0c3a1bf77f05334817c985b6535abdb2495c" => :el_capitan
  end

  depends_on "zsh"
  depends_on "autoconf" => :build

  def install
    args = %w[
      --disable-gdbm
      --enable-zpython
      --with-tcsetpgrp
    ]

    system "autoreconf"
    system "./configure", *args

    # Disable building docs due to exotic yodl dependency
    inreplace "Makefile", "subdir in Src Doc;", "subdir in Src;"

    system "make"
    (lib/"zpython/zsh").install "Src/Modules/zpython.so"
  end

  def caveats; <<~EOS
    To use the zpython module in zsh you need to
    add the following line to your .zshrc:

      module_path=($module_path #{HOMEBREW_PREFIX}/lib/zpython)

    If you want to use this with powerline, make sure you set
    it early in .zshrc, before your prompt gets initialized.

    After reloading your shell you can test with:
      zmodload zsh/zpython && zpython 'print "hello world"'
    EOS
  end

  test do
    system "zsh -c 'MODULE_PATH=#{HOMEBREW_PREFIX}/lib/zpython zmodload zsh/zpython && zpython print'"
  end
end
