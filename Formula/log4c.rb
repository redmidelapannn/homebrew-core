class Log4c < Formula
  desc "Logging Framework for C"
  homepage "https://log4c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"

  head "https://git.code.sf.net/p/log4c/log4c.git"

  bottle do
    rebuild 1
    sha256 "154c102a978172de176ec61ed384f758e22951d772555cc9a373b0b6ca851b8c" => :sierra
    sha256 "83ede834743c9f6b828e76a872899bde6f29a1b9b709ca404713051d046d0d9b" => :el_capitan
    sha256 "6d1266845191adaaa3be79cc1625ce4b5d47aa3f0021abdba8e71b43880c6f21" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
