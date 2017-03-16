class Ssed < Formula
  desc "Super sed stream editor"
  homepage "https://sed.sourceforge.io/grabbag/ssed/"
  url "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"

  bottle do
    rebuild 1
    sha256 "33cb8a7c9a032b0e5a4e299ed8b1a3809c9eb94e72aff56e11f277b671767f42" => :sierra
    sha256 "41673a5b5c17ce9121208377fadf0051ca40487bbaec4eae5f0dc0cb21d60b59" => :el_capitan
    sha256 "e7564f6562505fc0412e3e6ca238321b812e4d32165a594666dbc1d0d8fee8e7" => :yosemite
  end

  conflicts_with "gnu-sed", :because => "both install share/info/sed.info"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make", "install"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
