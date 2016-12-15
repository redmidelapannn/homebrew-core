class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://www.ccextractor.org"
  head "https://github.com/ccextractor/ccextractor.git"

  stable do
    url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.83/ccextractor.src.0.83.zip"
    sha256 "6ed32ba8424dc22fb3cca77776f2ee3137f5198cc2909711cab22fcc7cee470a"

    # Remove for > 0.83
    # Fix "fatal error: 'protobuf-c.h' file not found"
    # Upstream commit from 15 Dec 2016 "Added missing directory for protobuf-c."
    patch do
      url "https://github.com/CCExtractor/ccextractor/commit/6e17633.patch"
      sha256 "1a23b3e48708e60d73fffa09bb257b421ad2edab7de3d8d88c64f840c16564b3"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c6a39fd21d229e1bd5d012014dba07a270d63afc3605a12166f4ab82b269a31c" => :sierra
    sha256 "1e7ba0f2e144010c57399b67f3650898bf6b70d670bd6a783c1d9b5a2fbc91e3" => :el_capitan
    sha256 "8af0f87835295047257d2ce547d178a46fc15f6e19e41eb7c87e088cef731cc6" => :yosemite
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
