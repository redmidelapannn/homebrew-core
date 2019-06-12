class Ptpd < Formula
  desc "Precision Time Protocol daemon"
  homepage "https://github.com/ptpd/ptpd"
  url "https://downloads.sourceforge.net/project/ptpd/ptpd/2.3.1/ptpd-2.3.1.tar.gz"
  sha256 "0dbf54dd2c178bd9fe62481d2c37513ee36636d8bf137cfdad96891490cdbf93"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd546e204019e816385632d6382f7f86582bc6fb895d92902d8fa5a1b7008a80" => :mojave
    sha256 "9202428ee0dcb19fbc0b1730da412feaf8eb9fcde6200d385a24387606c56691" => :high_sierra
    sha256 "b28a99969bc19b1838d0154c6ecc23432b5d8ae1d1d62d2d9c4cad82d86bd9aa" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-snmp",
                          "--without-net-snmp-config",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/ptpd2", "--default-config"
  end
end
