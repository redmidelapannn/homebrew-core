class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.0.0.tar.gz"
  sha256 "4d9473681995c8fa87338edb2ddcb136f58abc72565d1ea2ba1b7dc3258c420e"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e9c5c050d4b0563e0cf1cccfa0238e4eae2662f28475ad72c958ad10e41385a" => :mojave
    sha256 "0abb0bc1f82c012a83e34fc0a33539786db867beb8f6003d154405d411b726ee" => :high_sierra
    sha256 "d9d7b320bc05fcb45c339a4652bcfddce38c2b8f8a43b199d441522958c545ec" => :sierra
  end

  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hairyhenderson/gomplate").install buildpath.children
    cd "src/github.com/hairyhenderson/gomplate" do
      system "make", "compress", "VERSION=#{version}"
      bin.install "bin/gomplate-slim" => "gomplate"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
