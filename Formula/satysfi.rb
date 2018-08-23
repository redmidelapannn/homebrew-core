class Satysfi < Formula
  desc "Statically-typed, functional typesetting system"
  homepage "https://github.com/gfngfn/SATySFi"
  url "https://github.com/gfngfn/SATySFi/archive/v0.0.2.tar.gz"
  sha256 "91b98654a99d8d13028d4c7334efa9d8cc792949b9ad1be5ec8b4cbacfaea732"

  bottle do
    cellar :any_skip_relocation
    sha256 "04129683963bdaf8c876391cc1bfd588fc129d27b898b75434f1844d3eae13c1" => :high_sierra
    sha256 "f211a49d657bbe99ec9225c925d64e82c71657bc99d54e05346edaa6db213e09" => :sierra
    sha256 "cb6dc1e19aa198b20dde3e38a5fe5b93054ea4e6738e868e5ac3efcbbfc1a53b" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    # mktemp to prevent opam from recursively copying a directory into itself
    mktemp do
      opamroot = Pathname.pwd/"opamroot"
      opamroot.mkpath
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--no-setup"

      # The same trick is used by xhyve.
      # (See docker-machine-driver-xhyve.rb#L47-L48 at 71576ce)
      inreplace "#{opamroot}/compilers/4.06.1/4.06.1/4.06.1.comp",
        '["./configure"', '["./configure" "-no-graph"' # Avoid X11

      system "opam", "switch", "4.06.1"
      system "opam", "config", "exec", "--",
             "opam", "repository", "add", "satysfi-external",
             "https://github.com/gfngfn/satysfi-external-repo.git"
      system "opam", "config", "exec", "--",
             "opam", "pin", "add", "-n", "satysfi", buildpath
      system "opam", "config", "exec", "--",
             "opam", "install", "satysfi", "--deps-only"
      system "opam", "config", "exec", "--",
             "make", "-C", buildpath, "PREFIX=#{prefix}"
    end
    system "make", "lib"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/satysfi 2>&1", 1)
    assert_equal "! [Error] no input file designation.\n", output
  end
end
