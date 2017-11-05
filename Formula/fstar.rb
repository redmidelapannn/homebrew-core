class Fstar < Formula
  desc "ML-like language aimed at program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.5.0",
      :revision => "fa9b1fda52216678e364656f5f40b3309ef8392d"
  revision 1
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7c16e2b64466f451d2b9483a84408663714642c3631b7956fa90b136acaf27d7" => :high_sierra
    sha256 "3fe0736210c97c681e172d6c39689f00f469358f835695fbff935cbc7e161ab0" => :sierra
    sha256 "9e020fdcc00f51c980fb1ac5d44dea91282e91f97b047a0d02e679f745683031" => :el_capitan
  end

  depends_on "opam" => :build
  depends_on "gmp"
  depends_on "ocaml" => :recommended

  # FStar uses a special cutting-edge release from the Z3 team.
  # As we don't depend on the standard release we can't use the z3 formula.
  resource "z3" do
    url "https://github.com/Z3Prover/z3.git",
        :revision => "1f29cebd4df633a4fea50a29b80aa756ecd0e8e7"
  end

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization
    ENV["OPAMROOT"] = buildpath/"opamroot"
    ENV["OPAMYES"] = "1"

    # Avoid having to depend on coreutils
    inreplace "src/ocaml-output/Makefile", "$(DATE_EXEC) -Iseconds",
                                           "$(DATE_EXEC) '+%Y-%m-%dT%H:%M:%S%z'"

    resource("z3").stage do
      system "python", "scripts/mk_make.py", "--prefix=#{libexec}"
      system "make", "-C", "build"
      system "make", "-C", "build", "install"
    end

    system "opam", "init", "--no-setup"
    inreplace "opamroot/compilers/4.05.0/4.05.0/4.05.0.comp",
      '["./configure"', '["./configure" "-no-graph"' # Avoid X11

    system "opam", "switch", "4.05.0"

    if build.stable?
      system "opam", "config", "exec", "opam", "install", "batteries=2.7.0",
             "zarith=1.5", "yojson=1.4.0", "pprint=20140424", "stdint=0.4.2",
             "menhir=20170712"
    else
      system "opam", "config", "exec", "opam", "install", "batteries", "zarith",
             "yojson", "pprint", "stdint", "menhir"
    end

    system "opam", "config", "exec", "--", "make", "-C", "src/ocaml-output"

    (libexec/"bin").install "bin/fstar.exe"
    (bin/"fstar.exe").write <<~EOS
      #!/bin/sh
      #{libexec}/bin/fstar.exe --smt #{libexec}/bin/z3 --fstar_home #{prefix} "$@"
    EOS

    (libexec/"ulib").install Dir["ulib/*"]
    (libexec/"contrib").install Dir["ucontrib/*"]
    (libexec/"examples").install Dir["examples/*"]
    (libexec/"tutorial").install Dir["doc/tutorial/*"]
    (libexec/"src").install Dir["src/*"]
    prefix.install "LICENSE-fsharp.txt"

    prefix.install_symlink libexec/"ulib"
    prefix.install_symlink libexec/"contrib"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"tutorial"
    prefix.install_symlink libexec/"src"
  end

  def caveats; <<~EOS
    F* code can be extracted to OCaml code.
    To compile the generated OCaml code, you must install
    some packages from the OPAM package manager:
    - brew install opam
    - opam install batteries zarith yojson pprint stdint menhir

    F* code can be extracted to F# code.
    To compile the generated F# (.NET) code, you must install
    the 'mono' package that includes the fsharp compiler:
    - brew install mono
    EOS
  end

  test do
    system "#{bin}/fstar.exe",
    "#{prefix}/examples/hello/hello.fst"
  end
end
