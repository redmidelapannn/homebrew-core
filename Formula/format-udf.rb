class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.4.0.tar.gz"
  sha256 "41f259471fce19b8b716ff73498cd9e6864ffebc3855ffb5be5d763f5397d765"

  bottle do
    cellar :any_skip_relocation
    sha256 "704648860f13afc4e9f61a76570721e1360a23073a72d39dcb428ea888eefc1a" => :el_capitan
    sha256 "caa9b26f2b16717506d259a6bdd5d17a432b037c833c4bf78427dbc4e6efc321" => :yosemite
    sha256 "9553a2733e25e6162ab7a93f32d148c3719b8d7ce20b6a7d9b600f31e8289b6d" => :mavericks
  end

  def install
    bin.install "format-udf.sh"
  end

  test do
    system "#{bin}/format-udf.sh", "-h"
  end
end
