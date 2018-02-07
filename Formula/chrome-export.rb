class ChromeExport < Formula
  desc "Convert Chrome’s bookmarks and history to HTML bookmarks files"
  homepage "https://github.com/bdesham/chrome-export"
  url "https://github.com/bdesham/chrome-export/archive/v2.0.tar.gz"
  sha256 "ff972c3d88b030b65823388e08cd65ebd8795f0674b5581e9e8fdf3a0f4dc7ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a993254e0e1bf36f442d4e7010dcff164ae79ba2820cfc3a2e6a1290b62c99b" => :high_sierra
    sha256 "3a993254e0e1bf36f442d4e7010dcff164ae79ba2820cfc3a2e6a1290b62c99b" => :sierra
    sha256 "3a993254e0e1bf36f442d4e7010dcff164ae79ba2820cfc3a2e6a1290b62c99b" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "export-chrome-bookmarks"
    bin.install "export-chrome-history"

    pkgshare.install "test"
  end

  test do
    cp_r "#{pkgshare}/test/.", "."

    system "#{bin}/export-chrome-bookmarks", "Bookmarks", "bookmarks_actual_output.html"
    compare_file "bookmarks_expected_output.html", "bookmarks_actual_output.html"
    system "#{bin}/export-chrome-history", "History", "history_actual_output.html"
    compare_file "history_expected_output.html", "history_actual_output.html"
  end
end
