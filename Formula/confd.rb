class Confd < Formula
  desc "Manage local application configuration files using templates"
  homepage "https://github.com/kelseyhightower/confd"
  url "https://github.com/kelseyhightower/confd/archive/v0.16.0.tar.gz"
  sha256 "4a6c4d87fab77aa9827370541024a365aa6b4c8c25a3a9cab52f95ba6b9a97ea"
  head "https://github.com/kelseyhightower/confd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8aaa0f9d1b2e95c516af908920f3b3cf46094bac624bccd902b1a9b0a1856a1" => :catalina
    sha256 "8e906ae8f026b6297eb5bd0caaefb5539b2ce5e5bed26a611b26b35961ca17ee" => :mojave
    sha256 "1c4387106dbb0ace3786ecaf5bd4adffb11a6c99559a0b0b4aa4fcebe19ed08f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kelseyhightower/confd").install buildpath.children
    cd "src/github.com/kelseyhightower/confd" do
      system "go", "install", "github.com/kelseyhightower/confd"
      bin.install buildpath/"bin/confd"
    end
  end

  test do
    templatefile = testpath/"templates/test.tmpl"
    templatefile.write <<~EOS
      version = {{getv "/version"}}
    EOS

    conffile = testpath/"conf.d/conf.toml"
    conffile.write <<~EOS
      [template]
      prefix = "/"
      src = "test.tmpl"
      dest = "./test.conf"
      keys = [
          "/version"
      ]
    EOS

    keysfile = testpath/"keys.yaml"
    keysfile.write <<~EOS
      version: v1
    EOS

    system "confd", "-backend", "file", "-file", "keys.yaml", "-onetime", "-confdir=."
    assert_predicate testpath/"test.conf", :exist?
    refute_predicate (testpath/"test.conf").size, :zero?
  end
end
