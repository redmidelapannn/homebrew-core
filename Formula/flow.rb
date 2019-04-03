class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.96.1.tar.gz"
  sha256 "13676723613ad7647b58ee8d7a46ede55b601ed04deeb58546a81be0af481b1a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b40ad3ea20cb9e881a98ee8ea7e723bb10c8b24531bbb4fb8fcf5c07722842c9" => :high_sierra
    sha256 "fd8d7e0461240cfde338f925094ae2dc3072f02feb613c346b8f0d4c992e3d3b" => :sierra
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
