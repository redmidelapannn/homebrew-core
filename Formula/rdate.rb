class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "https://www.aelius.com/njh/rdate/"
  url "https://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ba52c04f1da5fe0eabb0f3a45063f4207136cdcb5b0df5a0e1f42fbecaa0b762" => :catalina
    sha256 "90fb3c330955e41bacb54d854584f57ac0f7095548d00d6c7d5f42f262a425f1" => :mojave
    sha256 "0e5937a691f76ab5b8a6ec8bcb53c2afd2b4ead8f370346017cf9e84a0817809" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # note that the server must support RFC 868
    system "#{bin}/rdate", "-p", "-t", "10", "time-b-b.nist.gov"
  end
end
