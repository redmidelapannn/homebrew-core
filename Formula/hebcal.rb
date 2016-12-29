class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.11.tar.gz"
  sha256 "3b32b579c1153e29572b81c0b10a019c983200ac13f5423fff5caab10de28a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "124d8d686c08c0df51c677510126ed92bc2b0731cc2627944f4d698c0b8dab9c" => :sierra
    sha256 "b74724fc183f43732db2b1ae910eb566f1555be92e5f6e90aa04089bbdbb2cc6" => :el_capitan
    sha256 "bb04224c664ab61c340428dd364a0456166e96e55242dd573084371d44a50874" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
