class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.1.4.tar.gz"
  sha256 "8f844c64bc0d8e14cb104a83d0f5b66b7cfeb413b4bae590318103f6b8126327"

  bottle do
    cellar :any_skip_relocation
    sha256 "89d883152e213d8a38d933272d717ee0aaf229aa5958ad69285091dab09c2138" => :sierra
    sha256 "c2f11f9d4a5a97ee9867ed6d3bd516c228b81308e5b12eca6ac18dc52231cb82" => :el_capitan
    sha256 "4896da3820fe3fa49916753223379063137dc49cead42a4f652d5be9f7454ecc" => :yosemite
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"nodeenv", "--node=0.10.40", "--prebuilt", "env-0.10.40-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-0.10.40-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v0.10.40", shell_output("node -v")
  end
end
