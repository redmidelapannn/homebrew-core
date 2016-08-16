class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.82/ccextractor.src.0.82.zip"
  sha256 "890e7786256c74c7e4850592784da027451dd7c3e3a353c9bad3bea5467b7b77"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "751d82da4da84094bfbee0ef066ca479553dff8c26c704eb9af09e52798dcb24" => :el_capitan
    sha256 "8ca2396c78a19671777565674f2bd065254c00cff71689b50cb69f6f390db06b" => :yosemite
    sha256 "9544867e7b4550902d1b1fef13798306e83a2a43521ae5d6e8de9ef13ddf7eea" => :mavericks
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
