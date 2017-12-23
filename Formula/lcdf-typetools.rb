class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.106.tar.gz"
  sha256 "503c3869f73a392ae0ba41e0fc4f7672e70e2d66e8a81f3bb183f495183fa967"

  bottle do
    rebuild 1
    sha256 "832af67c260ecde3478ba53ce70984d84732cb0ec6c1614ab705940a099732c7" => :high_sierra
    sha256 "9333176439f803ae9dd75f62d8660027d30905ca53e451b2ee606cace0314276" => :sierra
    sha256 "66c946e6fa52efcb33abfec989baa1b3530456054a19c23ad4e7cbb9a36b9b57" => :el_capitan
  end

  conflicts_with "open-mpi", :because => "both install same set of binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end

  test do
    assert_match "STIXGeneral-Regular",
      shell_output("#{bin}/otfinfo -p /Library/Fonts/STIXGeneral.otf")
  end
end
