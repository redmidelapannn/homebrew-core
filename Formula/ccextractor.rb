class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://www.ccextractor.org"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.82/ccextractor.src.0.82.zip"
  sha256 "890e7786256c74c7e4850592784da027451dd7c3e3a353c9bad3bea5467b7b77"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b7c23a39efa663b11822464f8fe9476ee151919dd5bec6b2c47c30c53d347b64" => :el_capitan
    sha256 "5d3145847cc86309c19fcaab07918d13d13b8cc3af9faa45491390d5c5773777" => :yosemite
    sha256 "59332b8f540d9b6a0c791de82fb44c0af0562a2fd0b5b9f32a1b5c215922640f" => :mavericks
  end

  def install
    cd "mac" do
      system "./build.command"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    system bin/"ccextractor", "test"
    assert File.exist?("test.srt")
  end
end
