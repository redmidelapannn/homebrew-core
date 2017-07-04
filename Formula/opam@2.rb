class OpamAT2 < Formula
  desc "The OCaml package manager v2.0.0 (beta)"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.0-beta3/opam-full-2.0.0-beta3.tar.gz"
  sha256 "83d61052b29e7c08674852f4d607e5403720c5fd85664c3b340acf9a938fd9e6"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b38ba1dc0ab2a5d9323cb37c7fe1760c0d142888a1f669a4c58298f43dafd80" => :sierra
    sha256 "c7c2354c24026b4fda10aa1276b5c619d5d48b5df744290e0edaa6ee6469d1ce" => :el_capitan
    sha256 "e77d99fc9892d47f58736e0ae78c05fc49c4ab8225804c727f931be12b1ef72f" => :yosemite
  end

  depends_on "ocaml" => :recommended

  # aspcud has a fairly large buildtime dep tree, and uses gringo,
  # which requires C++11 and is inconvenient to install pre-10.8
  if MacOS.version > 10.7
    depends_on "aspcud" => :recommended
  else
    depends_on "aspcud" => :optional
  end

  needs :cxx11 if build.with? "aspcud"

  def install
    ENV.deparallelize

    if build.without? "ocaml"
      system "make", "cold", "CONFIGURE_ARGS=--prefix #{prefix} --mandir #{man}"
      ENV.prepend_path "PATH", "#{buildpath}/bootstrap/ocaml/bin"
    else
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "lib-ext"
      system "make"
    end
    system "make", "man"
    system "make", "install"

    bash_completion.install "shell/opam_completion.sh"
    zsh_completion.install "shell/opam_completion_zsh.sh" => "_opam"
  end

  def caveats; <<-EOS.undent
    OPAM uses ~/.opam by default for its package database, so you need to
    initialize it first by running (as a normal user):

    $  opam init

    Run the following to initialize your environment variables:

    $  eval `opam config env`

    To export the needed variables every time, add them to your dotfiles.
      * On Bash, add them to `~/.bash_profile`.
      * On Zsh, add them to `~/.zprofile` or `~/.zshrc` instead.

    Documentation and tutorials are available at https://opam.ocaml.org, or
    via "man opam" and "opam --help".
    EOS
  end

  test do
    system bin/"opam", "--help"
  end
end
