class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.6.1.tar.gz"
  sha256 "27e238f4cc48c19e1060ec8770a1c6eb55c3b837d9063aa99bc37e38d76b4a48"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "51c19d961c0aef64a704c8282e48f354d057a4b9530fb45ffe3597f78e6cdc40" => :high_sierra
    sha256 "5068844f37b682aa6dca650f2f2c9fd6d3b5f4ab299e9cd9e8f8e767b71b79e0" => :sierra
    sha256 "826cf43fcf1fcf9c5bb9d3c9d5ffdec3d6414ebee9ce092ae55dd81a73d851e6" => :el_capitan
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "asciidoctor.gemspec"
    system "gem", "install", "asciidoctor-#{version}.gem"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.adoc").write("= AsciiDoc is Writing Zen")
    system bin/"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
  end
end
