class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz"
  sha256 "b40e1d1273e08aaeaa86e69d4f28d535b7e53bdb3898adf539266b63137be7cb"

  bottle do
    cellar :any
    rebuild 2
    sha256 "d6a841e847f05d134a1bb8a9e42a9705db292a99a23e93f43f8efcd0a79eebdc" => :high_sierra
    sha256 "8d73f89b6b76b107aba76e22090819301ad254dbff97e224d57905c1ee2a52a6" => :sierra
    sha256 "01d6d37edc3d802c3a307112669080aadbfcf7920c48209db5ac68c2e1cad582" => :el_capitan
  end

  # libpcap on >= 10.12 has pcap_lib_version() instead of pcap_version
  # Reported 8 Oct 2017 to bugs AT snort DOT org
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b345dac/daq/patch-pcap-version.diff"
      sha256 "20d2bf6aec29824e2b7550f32251251cdc9d7aac3a0861e81a68cd0d1e513bf3"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <daq.h>
      #include <stdio.h>

      int main()
      {
        DAQ_Module_Info_t* list;
        int size = daq_get_module_list(&list);
        daq_free_module_list(list, size);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-o", "test"
    system "./test"
  end
end
