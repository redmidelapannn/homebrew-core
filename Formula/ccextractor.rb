class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.84/ccextractor.src.0.84.zip"
  sha256 "8825849021fd8bfaa99ea63fc3c7e3f442b54450a1e50e93bf8b51627ebe60a7"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0530d095c233d5f046615ae21505a841d855444bc9ac5d5d6044b4b7da92adb9" => :sierra
    sha256 "b4c1e7a26ac80e9dcdebc3864390a6b8a20cb5ef48f5d1d7719c352a6f4f015c" => :el_capitan
    sha256 "87df19e4a8bdf35fdec08667db6bcc46b382421ce30ed9466b78e77f146498e3" => :yosemite
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
