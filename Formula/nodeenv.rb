class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.1.4.tar.gz"
  sha256 "8f844c64bc0d8e14cb104a83d0f5b66b7cfeb413b4bae590318103f6b8126327"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e4acf7463e8aba68c53ad7888f6a81948c52e047b8efbba67b22c56adcb1d93" => :sierra
    sha256 "e6cce9684cf49e7698ee654ce6bf59ebe5d42ca842a657b571a6642b6c54c795" => :el_capitan
    sha256 "7b7a430a6334f157d1d59033a9ce4c49216666927127465df592cd4ad2e03c7d" => :yosemite
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
