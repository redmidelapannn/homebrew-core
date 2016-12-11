class ExcelCompare < Formula
  desc "Command-line tool (and API) for diffing Excel Workbooks"
  homepage "https://github.com/na-ka-na/ExcelCompare"
  url "https://github.com/na-ka-na/ExcelCompare/releases/download/0.6.0/ExcelCompare-0.6.0.zip"
  sha256 "63bda982644ec8633b60eed5bc199892c428b54addb2eb63dda0b894d98a56c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c5430ce6b6af46baec93cea9535594274c8f59e984e7fb40877a74857f7471d" => :sierra
    sha256 "fc8d6e9363a0d436e4a4c7ea3618d5d6f7a85e3da9d562125d3ac94cb06dbfe0" => :el_capitan
    sha256 "fc8d6e9363a0d436e4a4c7ea3618d5d6f7a85e3da9d562125d3ac94cb06dbfe0" => :yosemite
  end

  resource "sample_workbook" do
    url "https://github.com/na-ka-na/ExcelCompare/raw/0.6.0/test/resources/ss1.xlsx", :using => :nounzip
    sha256 "f362153aea24092e45a3d306a16a49e4faa19939f83cdcb703a215fe48cc196a"
  end

  def install
    libexec.install Dir["bin/dist/*"]

    (bin/"excel_cmp").write <<-EOS.undent
      #!/bin/sh
      java -ea -Xmx512m -cp "#{libexec}/*" com.ka.spreadsheet.diff.SpreadSheetDiffer "$@"
    EOS
  end

  test do
    resource("sample_workbook").stage testpath
    assert_match %r{Excel files #{testpath}/ss1.xlsx and #{testpath}/ss1.xlsx match},
      shell_output("#{bin}/excel_cmp #{testpath}/ss1.xlsx #{testpath}/ss1.xlsx")
  end
end
