class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.120.0.tar.gz"
  sha256 "359fbda66ae2ceb3f44bc5ac7617ca7039ccfb44ed09cae024e318275c5c6344"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec88867e2db4e62434589810c99ae33c9b7a108b3a9bf557ee31e51e62167f47" => :catalina
    sha256 "c263527c06153747cf7343fe81cd2a65b822318027f08142c86a104bf86c6c10" => :mojave
    sha256 "e8aaaafeec4988a4abbe7431cac330551f7dbfece2c0035653d5d851d11588cb" => :high_sierra
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
