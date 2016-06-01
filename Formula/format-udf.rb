class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.4.0.tar.gz"
  sha256 "41f259471fce19b8b716ff73498cd9e6864ffebc3855ffb5be5d763f5397d765"

  def install
    bin.install "format-udf.sh"
  end

  test do
    system "#{bin}/format-udf.sh", "-h"
  end
end
