class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.120.0.tar.gz"
  sha256 "359fbda66ae2ceb3f44bc5ac7617ca7039ccfb44ed09cae024e318275c5c6344"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecfeb51c5b4fcceb6f0389928745affc070c3cc3e5cd16cf2d80d201f66eac40" => :catalina
    sha256 "7588866f05df16a5f6471dfdb1243b757ebad529b300f7e05d8ac0a7375243f3" => :mojave
    sha256 "1bd9ed1e4fd2c922f84c7ff7f3bbfc538fcfd50681ae83d0c559d21d3286f30c" => :high_sierra
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
