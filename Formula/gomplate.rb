class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.3.0.tar.gz"
  sha256 "9a2280353504d7c68be97201180fcc7bea7fba00052c04d33bc9f350a7bbd6be"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ac745a9919a08842c0e39f80cb049a338cb570d469f4d6795551499ceec0c386" => :high_sierra
    sha256 "9eb128dfdba48bfeb15ad28ab5a111df891e5ead79e491f206ae3b8c91566443" => :sierra
    sha256 "62ef788a6f8fc5ca757fa932173419bb15cf26866b1897a0defc4d3533122361" => :el_capitan
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
