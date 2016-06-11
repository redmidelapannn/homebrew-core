class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.26.0.tar.gz"
  sha256 "7813c98f7509d89e5a187df4252dbf8e6c429b1d711e10156eccb1ac793fb571"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e576e9effe5c281fe5b51e5d11258310249d67dc364630bc3f5b5f6bcad4755a" => :el_capitan
    sha256 "442d9fe5db9cf450b2fafb65428f4c2ad925516d5c90d0afeb182af9db38fda6" => :yosemite
    sha256 "57553c3c9391c7337390833f424f0ca52252805cccf038fae47817b35bc7ea40" => :mavericks
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
