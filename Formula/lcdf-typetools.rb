class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.107.tar.gz"
  sha256 "46be885f4623e2e595f786c70e03264b680066de57789833db541f947a8edfdb"

  bottle do
    rebuild 1
    sha256 "f1f6fe980a301f7f7d33e486cdc3b822e5fb9f8bb856bc708e454f3e0cb97238" => :high_sierra
    sha256 "22a4fd02710f60835c8c94af11b68096e654cfced185bbce60458a72b3048b42" => :sierra
    sha256 "89901da0b1bc5ac9d178148aced6265e7c69f0e42e5ed0969f96f55b77b0a0b4" => :el_capitan
  end

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
