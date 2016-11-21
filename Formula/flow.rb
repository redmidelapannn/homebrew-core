class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.35.0.tar.gz"
  sha256 "c60efe9da95b578705ac61a4666af93a37401d973c37edae1865cd734aa2b95b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1025780e0bdd768148b519c6ece0281290abd33a9ad863b4adf1300b4e948f1d" => :sierra
    sha256 "8b59efdb9c92a1725e9eab49bd803d73a96e70d154720031f072346af9fa9f78" => :el_capitan
    sha256 "7a024245914f4db0b4a9f02d8bc70dc62f06c5082d8652f29fea7b4f98a6798d" => :yosemite
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
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
