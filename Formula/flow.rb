class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  # Switch back to archive tarball when possible.
  # https://github.com/facebook/flow/issues/1981
  url "https://github.com/facebook/flow.git",
    :tag => "v0.29.0",
    :revision => "75e8532c8de97011e2d7d5736f664cb133a5ccff"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eef3491b71109aba5030cdfd0ccae39eb2996820bc2959b59e89e7f7c68b78e4" => :el_capitan
    sha256 "7b0e868b423c9e6b63afd3f0ac1495b726f5e6c4e9f73b743b5db9ecdfcbd6eb" => :yosemite
    sha256 "13b40734e891d980a08c7a256cb6bce1020b05f8d122ebdb52b0b5cfab082a10" => :mavericks
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
