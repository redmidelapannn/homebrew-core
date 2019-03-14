class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.95.0.tar.gz"
  sha256 "abf78911375af0c768f73a626c2b3f3eeef8cf77a29179baa0724570413746d4"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4837e5cdbc8f129b9a22e6c95a2919b2ba0d836260facf674e14753762035696" => :mojave
    sha256 "ab2f1e346ce749cc74c027855f985152a45d5822265243ff58d00913ee85e8f6" => :high_sierra
    sha256 "d264106756ff83fe1a7785b8fdc2b6b65aff942de8f0099e87270a47f6caa669" => :sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
