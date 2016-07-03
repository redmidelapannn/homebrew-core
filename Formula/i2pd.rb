class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client."
  homepage "http://i2pd.website/"
  head "https://github.com/PurpleI2P/i2pd.git"

  stable do
    url "https://github.com/PurpleI2P/i2pd/archive/2.8.0.tar.gz"
    sha256 "3f3f538b3c5b3095021311b434456c42d6f3b5e43dc7972c263b10ef179ba063"
  end
  bottle do
    cellar :any
    sha256 "694ace3ff33409cf5a297a961bc2a256df48419d5943fc23ad24d4e67e673f4e" => :el_capitan
    sha256 "8bfbc79714d8a710cf6003ef4e9356ea24874a49828194916ca39c2f89942003" => :yosemite
    sha256 "378d6133729e4a8d2cdf697ffcef5d42240d5b6e88efe7c5a00cf076a7a90460" => :mavericks
  end


  depends_on "libressl"
  depends_on "boost"

  def install
    system "make", "HOMEBREW=1"

    bin.install "i2pd"
  end

  test do
    system "#{bin}/i2pd", "--help"
  end
end
