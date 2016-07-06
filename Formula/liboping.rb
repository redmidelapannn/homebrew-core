class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.8.0.tar.bz2"
  sha256 "1dcb9182c981b31d67522ae24e925563bed57cf950dc681580c4b0abb6a65bdb"

  bottle do
    revision 1
    sha256 "16fb7fb4f2f6475314ac749dc2e4cdaf7c9afd2a41efac36144eb52daf995bba" => :el_capitan
    sha256 "d6a78a5883f4f9037f1cbc0c3165d100fb4ad15e7955885df729bf3f986fb66c" => :yosemite
    sha256 "0422333ec95240b268f50d6cb8ec885de6775fb113537533bbbb9a58532f19e4" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end
end
