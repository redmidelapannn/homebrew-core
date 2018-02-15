class Cvsutils < Formula
  desc "CVS utilities for use in working directories"
  homepage "https://www.red-bean.com/cvsutils/"
  url "https://www.red-bean.com/cvsutils/releases/cvsutils-0.2.6.tar.gz"
  sha256 "174bb632c4ed812a57225a73ecab5293fcbab0368c454d113bf3c039722695bb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4bb7db959ec8b68d1f2cebb0d5ae2cd5f8652ada664f84b7b8f13ad5d049bc7" => :high_sierra
    sha256 "f4bb7db959ec8b68d1f2cebb0d5ae2cd5f8652ada664f84b7b8f13ad5d049bc7" => :sierra
    sha256 "f4bb7db959ec8b68d1f2cebb0d5ae2cd5f8652ada664f84b7b8f13ad5d049bc7" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cvsu", "--help"
  end
end
